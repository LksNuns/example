module Command
  # Find dolar and real average from a transaction
  class CalculateAverage < Command::Base
    attribute :negotiation
    attribute :asset
    attribute :traded_asset

    def execute
      if traded_asset.fiat?
        calculate_average_from_fiat_coin
      elsif traded_asset.stable?
        calculate_average_from_stable_coin
      else
        calculate_average_from_crypto_coin
      end
    end

    private

    def calculate_average_from_fiat_coin # rubocop:disable Metrics/AbcSize
      ::CalculateAverage::CalculateAverageFromFiatCoin.new({
        symbol: asset.coin.symbol,
        current_average_price_brl: asset.average_price_brl,
        current_average_price_usd: asset.average_price_usd,
        current_amount: asset.amount,
        amount: negotiation.amount,
        price: negotiation.price,
        dolar_market_price: negotiation.price_usd,
        date: negotiation.date
      }).execute
    end

    def calculate_average_from_stable_coin # rubocop:disable Metrics/AbcSize
      ::CalculateAverage::CalculateAverageFromStableCoin.new({
        symbol: asset.coin.symbol,
        current_average_price_brl: asset.average_price_brl,
        current_average_price_usd: asset.average_price_usd,
        current_amount: asset.amount,
        traded_coin_symbol: traded_asset.coin.symbol,
        current_stable_coin_average_price_brl: traded_asset.average_price_brl,
        amount: negotiation.amount,
        price: negotiation.price,
        date: negotiation.date
      }).execute
    end

    def calculate_average_from_crypto_coin # rubocop:disable Metrics/AbcSize
      ::CalculateAverage::CalculateAverageFromCryptoCoin.new(
        symbol: asset.coin.symbol,
        current_average_price_brl: asset.average_price_brl,
        current_average_price_usd: asset.average_price_usd,
        current_amount: asset.amount,
        real_market_price: negotiation.price_brl,
        traded_coin_current_average_price_brl: traded_asset.average_price_brl,
        traded_coin_current_average_price_usd: traded_asset.average_price_usd,
        amount: negotiation.amount,
        price: negotiation.price,
        date: negotiation.date
      ).execute
    end
  end
end
