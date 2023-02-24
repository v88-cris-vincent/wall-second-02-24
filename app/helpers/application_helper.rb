module ApplicationHelper
    def validate_fields(params, all_valid_fields)
        check_fields_response = { :status => true, :result => {}, :error => nil }
        incomplete_fields = []
        begin
            all_valid_fields.each do |key|
                if params[key].present?
                    check_fields_response[:result][key] = params[key].is_a?(String) ? params[key].strip : params[key]
                else
                    incomplete_fields << key
                end
            end

            check_fields_response.merge!((incomplete_fields.length > 0) ? {:result => incomplete_fields, :status => false} : {:result => check_fields_response[:result].symbolize_keys})
            
            if !check_fields_response[:status]
                check_fields_response[:error] = "Please fill the following fields (#{incomplete_fields})"
            end
  
        rescue => exception
             check_fields_response[:error] = "All fields #{incomplete_fields} are required"           
        end

        return check_fields_response
    end
end
