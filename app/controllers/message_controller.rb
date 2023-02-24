include ApplicationHelper
class MessageController < ApplicationController
    def index
        begin
            @messages = Message.organied_content
            
            if session[:user_id].nil?
                session[:user_id] = 1
                session[:first_name] = "Cris"
                session[:last_name] = "Castro"
            end
        rescue Exception => e
            @messages[:error] = {e.exception => e}
        end
    end

    def post_message
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            require_params = validate_fields(params, [:user_id, :message])

            if require_params[:status]
                response_data = Message.create_message(params, session[:first_name], params[:last_name])

                if response_data[:status]
                    response_data[:result][:html] = render_to_string :partial => "message/partials/message_content", :locals => {:messages => [response_data[:result][:message]] }
                else
                    response_data[:error] = response_data[:error]
                end
            else
                response_data[:error] = "Error Encountered"
            end

        rescue Exception => e
            response_data[:error] = {e.exception => e}
        end

        render :json => response_data
    end

    def delete_message
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            require_params = validate_fields(params, [:message_id, :message_user_id])

            raise "Error encountered" if !require_params[:status]

            response_data = Message.delete_message(require_params[:result])

            if !response_data[:status]
                response_data[:error] =  "Failed to delete message" 
            end

        rescue Exception => e
            response_data[:error] = {e.exception => e}
        end

        render :json => response_data
    end
end
