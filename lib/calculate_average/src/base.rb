module CalculateAverage
  class Base
    private

    def calculate_average(current_average, cost)
      ((current_average * current_amount) + cost) / total_amount
    end

    def total_cost
      price * amount
    end

    def total_amount
      current_amount + amount
    end
  end
end
