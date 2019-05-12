# frozen_string_literal: true

class GameRepository
  class << self
    def list_games
      Game.eager_load(:frames).all
    end

    def find_game_by_id(id)
      Game.find_by(id: id)
    end

    def create!(player_name:)
      Game.create!(player_name: player_name)
    end

    def end_game!(game:)
      game.update!(ended: true)
    end
  end
end
