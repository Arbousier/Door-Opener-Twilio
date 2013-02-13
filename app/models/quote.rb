QUOTES = YAML.load_file File.expand_path("../../../config/quotes.yml", __FILE__)
class Quote
  def self.random(lang = 'en')
    QUOTES['quotes'][lang][rand(QUOTES['quotes'].count - 1)]
  end
end