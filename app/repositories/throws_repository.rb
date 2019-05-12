# frozen_string_literal: true

class ThrowsRepository
  class << self
    def list_throws(game_id:, frame_number:)
      Frame.eager_load(:throws)
           .where(game_id: game_id, number: frame_number)
           .first&.throws
    end

    def find_frame_throw(game_id:, frame_number:, throw_number:)
      Frame.eager_load(:throws)
           .where(game_id: game_id, number: frame_number)
           .where('throws.number = ?', throw_number)
           .first&.throws&.first
    end

    def create!(frame:, points:, number:)
      Throw.create!(
        frame: frame,
        points: points,
        number: number
      )
    end
  end
end
