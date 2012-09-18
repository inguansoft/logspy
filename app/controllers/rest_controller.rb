class RestController < MenuCookController
  layout false

  def service
    if @session_member and @session_member.id > 0
      entity = params[:entity]
      parameters = (params[:custom_parameters]) ? params[:custom_parameters].to_hash : nil
      class_obj = MenucookEntity.get_class_obj_for_webservices(entity)

      if class_obj
        if request.get?  #############GET - Read
          result = class_obj.web_read(parameters, @session_member)
        else
          if request.post? #############POST - Create
            result = class_obj.web_create(parameters, @session_member)
          else
            if request.put? #############PUT - Update
              result = class_obj.web_update(parameters, @session_member)
            else
              if request.delete? #############DELETE - Delete
                result = class_obj.web_delete(parameters, @session_member)
              end
            end
          end
        end
        render :json => class_obj.json_stream(result)
        return
      end
    end
    render :json => "{ }"
  end
  
end
