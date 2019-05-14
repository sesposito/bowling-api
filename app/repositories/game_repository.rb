# frozen_string_literal: true

class GameRepository
  class << self
    def list_games
      Game.eager_load(:frames).all
    end

    def find_game_by_id(id)
      Game.find_by(id: id)
    end

    def create!(player_name:, current_frame_number:)
      Game.create!(player_name: player_name, current_frame_number: 1)
    end

    def update_current_frame_number!(game:, number:)
      game.update!(current_frame_number: number)
    end

    def end_game!(game:)
      game.update!(ended: true)
    end
  end
end
