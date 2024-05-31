module CalculateAverage
  class CalculateAverageFromCryptoCoin < Base
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment
    include ActiveModel::Validations

    attribute :symbol, :string
    attribute :current_average_price_brl, :decimal
    attribute :current_average_price_usd, :decimal
    attribute :current_amount, :decimal
    attribute :amount, :decimal
    attribute :price, :decimal
    attribute :traded_coin_current_average_price_brl, :decimal
    attribute :traded_coin_current_average_price_usd, :decimal
    attribute :date, :datetime
    attribute :real_market_price, :decimal

    def initialize(attributes)
      super()

      assign_attributes(attributes.symbolize_keys.slice(*CalculateAverageFromCryptoCoin.attribute_names.map(&:to_sym)))
    end

    def execute
      if to_stable_coin?
        raise StandardError.new('real_market_price is blank, impossible to calculate average') if real_market_price.blank?

        return {
          average_price_brl: calculate_average(current_average_price_brl, real_market_price * amount),
          average_price_usd: 1
        }
      end

      # There are two possible outcomes for this calculation:
      #
      # 1 - Assuming that you are realizing your profit/loss and purchasing the asset at the market price.
      # In this scenario, both the sell and buy transactions must be considered.
      #
      # 2 - Assuming that you are not realizing your profit/loss, in which case,
      # you are using your average price for the asset, not the market price on the day.
      #
      # Currently, we are adopting the second approach.
      brl_cost = traded_coin_current_average_price_brl * total_cost
      usd_cost = traded_coin_current_average_price_usd * total_cost

      {
        average_price_brl: calculate_average(current_average_price_brl, brl_cost),
        average_price_usd: calculate_average(current_average_price_usd, usd_cost)
      }
    end

    private

    def to_stable_coin?
      CalculateAverage::STABLE_COINS.include?(symbol)
    end
  end
end
