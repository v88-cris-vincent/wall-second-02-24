class Message < ApplicationRecord
    include :: QueryHelper

    def self.organied_content
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            content = query_select_all([
                "SELECT
                    messages.id AS message_id,
                    messages.user_id AS user_id,
                    messages.message AS message,
                    messages.created_at AS created_at,
                        (
                            SELECT
                                JSON_ARRAYAGG(
                                    JSON_OBJECT(
                                        'comment_id', comments.id,
                                        'user_id', comments.user_id,
                                        'message_id', comments.message_id,
                                        'comment', comments.comment,
                                        'created_at', comments.created_at
                                    )
                                )
                            FROM comments
                            WHERE messages.id = comments.message_id
                            ORDER BY created_at ASC
                        ) AS comment
                    FROM messages
                    GROUP BY messages.id
                    ORDER BY created_at DESC;"
            ])

            if content.present?
                response_data[:status] = true
                response_data[:result] = content
            else
                response_data[:error] = "failed to get message and comment"
            end

        rescue Exception => e
            response_data[:error] = e
        end

        return response_data
    end

    def self.create_message(params, first_name, last_name)
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            insert_message_record = query_insert([
                "INSERT INTO messages (user_id, message, created_at, updated_at) VALUES (?, ?, NOW(), NOW());",
                params[:user_id],params[:message]
            ])

            if insert_message_record
                response_data[:status] = true
                response_data[:result] = {
                    message: {
                        "message_id" => insert_message_record,
                        "user_id" => params[:user_id].to_i,
                        "message" => params[:message],
                        "created_at" => DateTime.now,
                        "comment" => nil
                    }
                }
            else
                response_data[:error] = "Encountered error in insert message"
            end

        rescue Exception => e
            response_data[:error] = e
        end

        return response_data
    end

    def self.delete_message(params)
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            message_id = query_delete(["
                DELETE FROM messages WHERE id = ? AND user_id = ?;",
                params[:message_id], params[:message_user_id]
            ])

            response_data[:status] = true
            response_data[:result] = message_id            

        rescue Exception => e
            response_data[:error] = e
        end

        return response_data
    end
end
