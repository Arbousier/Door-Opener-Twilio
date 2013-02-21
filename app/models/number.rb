# encoding: UTF-8
CLOUDANT = {'host' => ENV['CLOUDANT_HOST'],
  'key' => ENV['CLOUDANT_KEY'],
  'password' => ENV['CLOUDANT_PASSWORD']}
# number model
class Number
  def self.host
    "https://#{CLOUDANT['key']}:#{CLOUDANT['password']}@#{CLOUDANT['host']}"
  end
  def self.get_ids
    _a = []
    _l = "#{Number.host}/_all_docs"
    RestClient.get(_l, :content_type => :json,
      :accept => :json) do |response, request, result, &block|
        case response.code
        when 200
          JSON.parse(response.body)['rows'].each { |i| _a << i['id'] }
        when 404
          true
        end
      end
      _a
  end
  def self.all
    _a = []
    Number.get_ids.each do |id|
      _a << Number.get(:number => id)
    end
    _a
  end

  def self.get(hsh = {})
    _l = "#{Number.host}/#{hsh[:number].gsub('+','')}"
    RestClient.get(_l, :content_type => :json,
      :accept => :json) do |response, request, result, &block|
        case response.code
        when 200
          return JSON.parse(response.body)
        end
      end
  end

  def self.numbers
    Number.all.map(&:number)
  end

  def self.on_duty
    ENV['ON_DUTY'] || Number.all.first
  end

  def authorized?
    Number.numbers.include?(@phone_number)
  end
end