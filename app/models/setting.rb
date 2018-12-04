class Setting < ApplicationRecord

    def self.get(key)

        @query = Setting.where(key: key)
        if @query.length != 0
            @query.first.value
        else
            nil
        end
    end

    def self.insert(key, value)

        @query = Setting.where(key: key)
        if @query.length != 0
            @query.first.update(value: value)
        else
            Setting.create(key: key, value: value)
        end
    end
    
end
