class Bill < ApplicationRecord
    belongs_to :secret

    after_create :balance_secret
    after_update :balance_secret

    def balance_secret
        self.secret.balance
    end

    def close(plan_id)
        @plan = Plan.find(plan_id)

        @ref_end = Date.today - 1

        @days_used = @ref_end - self.ref_start + 1
        
        @days_reference = 30
        @ref_start = self.ref_start
        if @ref_start.day >= 6
            @starting_point_reference = @ref_start + (6 - @ref_start.day)
            @ending_point_reference = Date.new((@ref_start + 1.month).year, (@ref_start + 1.month).month, 5)
        else
            @starting_point_reference = @ref_start + (6 - @ref_start.day) - 1.month
            @ending_point_reference = Date.new(@ref_start.year, @ref_start.month, 5)
        end

        @days_reference = @ending_point_reference - @starting_point_reference + 1

        @value = (@days_used / @days_reference) * @plan.value

        self.update(ref_end: @ref_end, value: @value)
    end
end
