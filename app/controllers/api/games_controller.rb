module Api
  class GamesController < ApiController
    def show
      render(status: 200, json: {message: :success!}.to_json)
    end
  end
end
