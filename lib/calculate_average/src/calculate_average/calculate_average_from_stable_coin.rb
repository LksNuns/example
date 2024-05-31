module CalculateAverage
  class CalculateAverageFromStableCoin < Base
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment
    include ActiveModel::Validations

    attribute :symbol, :string
    attribute :traded_coin_symbol, :string
    attribute :current_average_price_brl, :decimal
    attribute :current_average_price_usd, :decimal
    attribute :current_amount, :decimal
    attribute :amount, :decimal
    attribute :price, :decimal
    attribute :current_stable_coin_average_price_brl, :decimal
    attribute :date, :datetime

    def initialize(attributes)
      super()
      assign_attributes(attributes.symbolize_keys.slice(*CalculateAverageFromStableCoin.attribute_names.map(&:to_sym)))

      raise StandardError.new('You cannot calculate from a not stable coin') unless from_stable_coin?
    end

    def execute
      brl_cost = current_stable_coin_average_price_brl * total_cost

      {
        average_price_brl: calculate_average(current_average_price_brl, brl_cost),
        average_price_usd: to_stable_coin? ? 1 : calculate_average(current_average_price_usd, total_cost)
      }
    end

    private

    def from_stable_coin?
      CalculateAverage::STABLE_COINS.include?(traded_coin_symbol)
    end

    def to_stable_coin?
      CalculateAverage::STABLE_COINS.include?(symbol)
    end
  end
end
