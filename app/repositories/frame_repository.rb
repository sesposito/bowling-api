# frozen_string_literal: true

class FrameRepository
  class << self
    def list_frames(game_id:)
      Frame.eager_load(:throws).where(game_id: game_id)
    end

    def find_frame(game_id:, frame_number:)
      Frame.find_by(game_id: game_id, number: frame_number)
    end

    def update_previous_frames_scores!(game_id:, frame_number:, points:)
      frames = Frame.where(game_id: game_id)
                    .where('bonus_throws > ?', 0)
                    .where('number < ?', frame_number)
      frames.each do |frame|
        frame.update!(
          points: frame.points + points,
          bonus_throws: frame.bonus_throws - 1
        )
      end
    end

    def create!(game_id:, number:)
      Frame.create!(
        game_id: game_id,
        number: number
      )
    end

    def update!(frame:, data:)
      frame.update!(data.compact)
    end
  end
end
