class NotificationsController < ApplicationController
  def index
    @notifications = policy_scope(Notification).where(read:false).order(accessed_at: :desc)
    @site = Site.new
  end
end
