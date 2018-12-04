class Setting < ApplicationRecord

    def get(key)

        @query = Setting.where(key: key)
        if @query.length != 0
            @query.first.value
        else
            nil
        end
    end

    def insert(key, value)

        @query = Setting.where(key: key)
        if @query.length != 0
            @query.first.update(value: value)
        else
            Setting.create(key: key, value: value)
        end
    end
    
end
