# encoding: UTF-8
# door model
class Door
  def self.open
    Net::HTTP.get_response(URI.parse (ENV['DOOR_URL']))
  end
end