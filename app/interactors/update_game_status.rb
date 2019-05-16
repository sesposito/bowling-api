# frozen_string_literal: true

class UpdateGameStatus
  def initialize(
    game:,
    throw:,
    current_frame:,
    frame_repository: FrameRepository,
    game_repository: GameRepository,
    frame_status_class: FrameStatus
  )
    @game = game
    @throw = throw
    @current_frame = current_frame
    @frame_repository = frame_repository
    @game_repository = game_repository
    @frame_status = frame_status_class
  end

  def call
    frame_results = frame_status.new(frame: current_frame, throw: throw).call
    frame_repository.update!(
      frame: current_frame,
      data: frame_results
    )

    update_previous_frames_scores

    if final_frame? && frame_results.ended
      game_repository.end_game!(game: game)
    elsif frame_results.ended
      create_new_frame
    end
  end

  private

  attr_reader :game, :throw, :current_frame, :frame_repository, :game_repository, :frame_status

  def final_frame?
    current_frame.number == 10
  end

  def update_previous_frames_scores
    frame_repository.update_previous_frames_scores!(
      game_id: game.id,
      frame_number: current_frame.number,
      points: throw.points
    )
  end

  def create_new_frame
    new_frame_number = current_frame.number + 1
    game_repository.update_current_frame_number!(game: game, number: new_frame_number)
    frame_repository.create!(game_id: game.id, number: new_frame_number)
  end
end
