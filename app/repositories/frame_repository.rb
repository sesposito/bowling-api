# frozen_string_literal: true

class FrameRepository
  DEFAULTS = {
    points: 0,
    spare: false,
    strike: false,
    ended: false,
    bonus_throws: 0
  }.freeze

  class << self
    def list_game_frames(game_id:)
      Frame.eager_load(:throws).where(game_id: game_id)
    end

    def find_game_frame(game_id:, frame_number:)
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

    def update!(frame:, struct:)
      frame.update!(struct.to_h.compact)
    end
  end
end
