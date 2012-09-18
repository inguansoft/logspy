class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :ensure_session_for_everyone

  #run this for every access to make sure we get a strong linkage with every visitor or member
  def ensure_session_for_everyone
    if session[:member_id]
      @session_member = Member.session_member(session[:member_id])
      if @session_member == nil #and DeploySettings.forced_member?
        @session_member = Member.guest
      end
    else
      #if DeploySettings.forced_member?
        @session_member = Member.guest
      #end
    end
    session[:member_id] = @session_member.id
  end

end
