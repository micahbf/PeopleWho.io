class CurrencyIndex
  include HTTParty
  base_uri 'openexchangerates.org/api'

  def initialize
    @app_id = ENV["OPEN_EXCHANGE_RATES_APP_ID"]
  end

  def currency_list
    self.class.get('/currencies.json', { query: { app_id: @app_id } })
  end

  def currency_rates
    parsed_hash = self.class.get('/latest.json', { query: { app_id: @app_id } })
    parsed_hash['rates']
  end
end