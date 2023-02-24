module QueryHelper
    extend ActiveSupport::Concern
    module ClassMethods

        def query_select_one(query_statement)
            return ActiveRecord::Base.connection.select_one(ActiveRecord::Base.send(:sanitize_sql_array, query_statement))
        end

        def query_select_all(query_statement)
            return ActiveRecord::Base.connection.exec_query(ActiveRecord::Base.send(:sanitize_sql_array, query_statement))
        end

        def query_update(query_statement)
            return ActiveRecord::Base.connection.update(ActiveRecord::Base.send(:sanitize_sql_array, query_statement))
        end

        def query_delete(query_statement)
            return ActiveRecord::Base.connection.delete(ActiveRecord::Base.send(:sanitize_sql_array, query_statement))
        end

        def query_insert(query_statement)
            return ActiveRecord::Base.connection.insert(ActiveRecord::Base.send(:sanitize_sql_array, query_statement))
        end
    end
end