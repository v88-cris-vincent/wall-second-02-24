class Comment < ApplicationRecord
    belongs_to :message
    include :: QueryHelper

    def self.create_comment(params, first_name, last_name)
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            comment_id = query_insert([
                "INSERT INTO comments (user_id, message_id, comment, created_at, updated_at) VALUES (?, ?, ?, NOW(), NOW());",
                params[:user_id],params[:message_id], params[:comment]
            ])

            if comment_id
                response_data[:status] = true
                response_data[:result] = {
                    comment: {
                        "comment" => params[:comment],
                        "user_id" => params[:user_id].to_i,
                        "message" => params[:message],
                        "created_at" => DateTime.now.to_s,
                        "message_id" => params[:message_id].to_i
                    }
                }
            else
                response_data[:error] = "Encountered error in insert comment"
            end

        rescue Exception => e
            response_data[:error] = e
        end

        return response_data
    end

    def self.delete_comment(params)
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            comment_id = query_delete(["
                DELETE FROM comments WHERE id = ? AND user_id = ?;",
                params[:comment_id], params[:comment_user_id]
            ])

            response_data[:status] = true
            response_data[:result] = message_id            

        rescue Exception => e
            response_data[:error] = e
        end

        return response_data
    end
end
