module BinanceSdk
  # Binance Sdk
  class Main
    def initialize
      @conn = Faraday.new(
        url: 'https://api.binance.com'
      ) do |f|
        f.request :json
        f.response :json
      end
    end

    # api/v3/klines response:
    # [
    #   [
    #     1499040000000,      // Open time
    #     "0.01634790",       // Open
    #     "0.80000000",       // High
    #     "0.01575800",       // Low
    #     "0.01577100",       // Close
    #     "148976.11427815",  // Volume
    #     1499644799999,      // Close time
    #     "2434.19055334",    // Quote asset volume
    #     308,                // Number of trades
    #     "1756.87402397",    // Taker buy base asset volume
    #     "28.46694368",      // Taker buy quote asset volume
    #     "17928899.62484339" // Ignore.
    #   ]
    # ]
    def market_price(symbol:, date:)
      # %Q - Number of milliseconds
      start_time = date.strftime("%Q").to_i

      response = @conn.get('/api/v3/klines', {
        interval: '1m',
        startTime: start_time,
        symbol:
      }.as_json)

      raise "Invalid #{response.body}" if response.status > 399

      # Get "open" value from response
      response.body.first[1].to_f
    end
  end
end
