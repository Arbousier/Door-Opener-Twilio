# encoding: UTF-8

class Door
  def self.open
    Net::HTTP.get_response(URI.parse (ENV['DOOR_URL']))
  end
end