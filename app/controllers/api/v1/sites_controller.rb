class Api::V1::SitesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: %i[index]
  before_action :set_site, only: %i[update]

  def index
    @sites = policy_scope(Site)
  end

  def create
    risk_results = CheckRisk.call(params[:site])
    @site = Site.new(site_params)
    @site.user = current_user
    authorize @site
    if @site.save && risk_results[:risk_score] > 0
      render :index, status: :created
    else
      render_error
    end
  end

  private

  def set_site
    @site = Site.find(params[:id])
    authorize @site
  end

  def site_params
    params.require(:site).permit(:url, :reason, :referral_site, :notification_id)
  end

  def render_error
    render json: { errors: @site.errors.full_messages },
      status: :unprocessable_entity
  end
end