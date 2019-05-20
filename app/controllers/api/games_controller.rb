# frozen_string_literal: true

module Api
  class GamesController < ApiController
    include GameLookup

    def index
      games_representer = Representers::GamesRepresenter.new(games)
      render(status: :ok, json: games_representer.to_json)
    end

    def show
      game = find_game_by_id!(params[:id])

      game_representer = Representers::GameRepresenter.new(game_data(game))
      render(status: :ok, json: game_representer.to_json)
    end

    def create
      parsed_body = parse_body!
      new_game = CreateNewGame.new(parsed_body).call

      game_representer = Representers::GameRepresenter.new(game_data(new_game))
      render(status: 201, json: game_representer.to_json)
    end

    def destroy
      game = find_game_by_id!(params[:id])
      GameRepository.destroy!(game: game)

      render(status: :no_content)
    end

    private

    def games
      games = GameRepository.list_games
      Games.new(games: games.map { |g| game_data(g) })
    end

    def game_data(game)
      Game.new(
        id: game.id,
        player_name: game.player_name,
        current_frame: game.current_frame_number,
        total_points: game.frames.sum(&:points),
        ended: game.ended
      )
    end

    def parse_body!
      body = request.body.read
      parsed_body = MultiJson.load(body, symbolize_keys: true)

      raise Errors::ValidationError, 'Missing "player_name" key' unless parsed_body.key?(:player_name)
      raise Errors::ValidationError, '"player_name" cannot be empty' if parsed_body[:player_name].blank?

      parsed_body
    rescue MultiJson::ParseError
      raise Errors::BadRequestError, 'Invalid JSON'
    end

    Game = Struct.new(:id, :player_name, :current_frame, :total_points, :ended, keyword_init: true)
    Games = Struct.new(:games, keyword_init: true)
  end
end
