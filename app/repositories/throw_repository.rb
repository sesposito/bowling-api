# frozen_string_literal: true

class ThrowRepository
  class << self
    def list_throws(game_id:, frame_number:)
      Throw.joins(:frame)
           .where(game_id: game_id)
           .where('frames.number = ?', frame_number)
    end

    def find_throw(game_id:, frame_number:, throw_number:)
      Throw.joins(:frame)
           .where(game_id: game_id, number: throw_number)
           .where('frames.number = ?', frame_number)
           .first
    end

    def create!(game:, frame:, points:, number:)
      Throw.create!(
        game: game,
        frame: frame,
        points: points,
        number: number
      )
    end
  end
end
