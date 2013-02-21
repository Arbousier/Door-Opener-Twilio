# encoding: UTF-8

class Notifier

  class << self
    def notify username
      RestClient.post url, hash_for(username)
    end

  private

    def url
      "https://api.flowdock.com/v1/messages/chat/#{ENV['FLOWDOCK_FLOW_TOKEN']}"
    end

    def hash_for username
      {
        external_user_name: username,
        content: "J'ouvre la porte de Tau...",
        tags: [ '#door' ]
      }
    end
  end
end