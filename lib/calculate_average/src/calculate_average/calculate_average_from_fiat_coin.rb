module CalculateAverage
  class CalculateAverageFromFiatCoin < Base
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment
    include ActiveModel::Validations

    attribute :symbol, :string
    attribute :current_average_price_brl, :decimal
    attribute :current_average_price_usd, :decimal
    attribute :amount, :decimal
    attribute :current_amount, :decimal
    attribute :price, :decimal
    attribute :dolar_market_price, :decimal
    attribute :date, :datetime

    def initialize(attributes)
      super()

      assign_attributes(attributes.symbolize_keys.slice(*CalculateAverageFromFiatCoin.attribute_names.map(&:to_sym)))
    end

    def execute
      averages = {
        average_price_brl: calculate_average(current_average_price_brl, total_cost),
        average_price_usd: 1
      }

      # Case it is an stable coin average_price_usd will be 1.
      return averages if to_stable_coin?

      usd_cost = (dolar_market_price || calculate_dolar_market_price) * amount
      averages[:average_price_usd] = calculate_average(current_average_price_usd, usd_cost)

      averages
    end

    private

    def to_stable_coin?
      CalculateAverage::STABLE_COINS.include?(symbol)
    end

    # When we have the price in BRL fiat coin
    # we must find the value related to dolar
    # if it is not present
    # Ex:
    #   BTCUSDT => value in dolars
    def calculate_dolar_market_price
      binance_sdk = BinanceSdk::Main.new

      binance_symbol = "#{symbol}USDT"
      binance_sdk.market_price(symbol: binance_symbol, date:)
    end
  end
end
