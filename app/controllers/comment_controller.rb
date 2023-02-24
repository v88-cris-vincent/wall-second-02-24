include ApplicationHelper
class CommentController < ApplicationController
    def post_comment
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            require_params = validate_fields(params, [:user_id, :comment])

            if require_params[:status]
                response_data = Comment.create_comment(params, session[:first_name], params[:last_name])

                if response_data[:status]
                    response_data[:result][:html] = render_to_string :partial => "comment/partials/comment", :locals => {:comments => [response_data[:result][:comment]] }
                else
                    response_data[:error] = response_data[:error]
                end
            else
                response_data[:error] = "Error Encountered"
            end

        rescue Exception => e
            response_data[:error] = {e.exception => e}
        end
        puts response_data
        render :json => response_data
    end

    def delete_comment
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            require_params = validate_fields(params, [:comment_id, :comment_user_id])

            raise "Error encountered" if !require_params[:status]

            response_data = Comment.delete_comment(params)

            if !response_data[:status]
                response_data[:error] =  "Failed to delete comment" 
            end

        rescue Exception => e
            response_data[:error] = {e.exception => e}
        end

        render :json => response_data
    end
end
