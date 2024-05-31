# Command
The `app/commands` directory contains all possible "actions" (primarily for writing data to the database). This structure follows the Command design pattern, aiming to isolate unique operations. Each command class has a single method, `execute_command`, which executes the associated action.

For example, the `Command::CalculateAverage` class simplifies the process of obtaining average prices. You only need to provide three models, and it handles the complexities internally using a specialized library designed to calculate average prices based on the currency type.

### Example of Usage:
```ruby
result = Command::CalculateAverage.new(negotiation:, asset:, traded_asset:).execute_command
```

# `calculate_average` lib
This is a small and simple library designed to calculate average prices in BRL and USD currencies based on your cryptocurrency transactions.

*NOTE:* Currently, we consider the FIAT currency to be `BRL` only.

## What It Does
In cryptocurrency calculations, we need to consider three possible scenarios:
1. Calculating the average from a FIAT coin
2. Calculating the average from a stable coin
3. Calculating the average from a crypto coin

Each scenario requires a different approach to calculate the average.

### Extra Case for Calculating Crypto Coin Average

There are two possible outcomes for this calculation:

- **Profit/Loss Removal Scenario:** This considers that you are removing your profit or loss and buying the asset at the market price. In this scenario, both sell and buy transactions are considered.

- **Average Price Maintenance Scenario:** This considers maintaining your average price for the asset, rather than using the market price on the day. Currently, this is the approach we are taking.

## How to Use

Here is an example of how to use the library:

```ruby
::CalculateAverage::CalculateAverageFromFiatCoin.new({
  symbol: 'BTC',
  current_average_price_brl: 120,000.0,
  current_average_price_usd: 24,500.0,
  current_amount: 0.1,
  amount: 0.1,
  price: 60,000,
  dollar_market_price: 19,000.0,
  date: Date.parse('2023-01-01')
}).execute

# Output
# => { average_price_brl: 90,000.0, average_price_usd: 21,750.0 }
```

Necessary fields for `CalculateAverageFromStalbeCoin`
```
current_average_price_brl
current_average_price_usd
current_amount
traded_coin_symbol
current_stable_coin_average_price_brl:average_price_brl
amount
price
date
```

Necessary fields for `CalculateAverageFromCryptoCoin`
```
current_average_price_brl
current_average_price_usd
current_amount
traded_coin_current_average_price_brl
average_price_brl
traded_coin_current_average_price_usd
average_price_usd
amount
price
date
```
