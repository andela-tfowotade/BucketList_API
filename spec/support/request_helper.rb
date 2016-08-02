module Requests
  module JsonHelpers
    def body
      JSON.parse(response.body)
    end
  end
end