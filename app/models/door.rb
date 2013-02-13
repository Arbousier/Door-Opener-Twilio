# encoding: UTF-8

class Door
  def self.open
    if production?
      Net::HTTP.get_response(URI.parse (ENV['DOOR_URL']))
    else
      true
    end
  end
end