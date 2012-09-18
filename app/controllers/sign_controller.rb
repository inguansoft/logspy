class SignController < MenuCookController
  layout false
  
  def up
    if @session_member
      @session_member.system_name = params[:custom_parameters][:email];
      @session_member.first_name = params[:custom_parameters][:first_name];
      @session_member.last_name = params[:custom_parameters][:last_name];
      @session_member.encrypted_password= params[:custom_parameters][:password];
      @session_member.process_password
      if(@session_member.save)
        StateMachine.set_status_on(@session_member, Status::PENDING, @session_member)
        session[:member_id] = @session_member.id
        render :json => Member.json_stream(@session_member)

        MemberMailer.welcome(@session_member).deliver

        
        return
      else
        #TODO: Need to improve constraints management
        json_stream = "{ \"entity\" : \"error\", \"messages\" : \""

        @session_member.errors.each do | this_error |
          json_stream = json_stream + Member::HUMANIZED_COLLUMNS[this_error[0]] + " " + this_error[1]
        end
        json_stream = json_stream + "\" }"
        render :json => json_stream
        return
      end
    end
    render :json => "{ }"
  end

  def in
    #TODO:Implement remember me
    #TODO: Do we want to take any changes from Mr guest?
    @session_member = Member.web_read(params[:custom_parameters].to_hash)
    if @session_member
      session[:member_id] = @session_member.id
      render :json => Member.json_stream(@session_member)
    else
      #TODO: Need to improve constraints management
      json_stream = "{ \"entity\" : \"error\", \"messages\" : \"member search didn't succeed!\" }"
      render :json => json_stream
    end
  end

  def check
    if @session_member and !(@session_member.is_guest?)
      render :json => Member.json_stream(@session_member)
    else
      render :json => "{ }"
    end
  end

  def off
    session[:member_id] = nil
    @session_member = nil
    render :json => "{ }"
  end
end
