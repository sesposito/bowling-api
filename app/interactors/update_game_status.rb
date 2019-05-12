# frozen_string_literal: true

class UpdateGameStatus
  def initialize(
    game:,
    bowl:,
    current_frame:,
    frame_repository: FrameRepository,
    game_repository: GameRepository
  )
    @game = game
    @bowl = bowl
    @current_frame = current_frame
    @previous_throw = current_frame.throws.max_by(&:number)
    @frame_repository = frame_repository
    @game_repository = game_repository
  end

  def call
    frame_results = new_frame_results
    frame_repository.update!(frame: current_frame, struct: FrameRepository::DEFAULTS.merge(frame_results))
    update_previous_frames_scores
    create_new_frame if !final_frame? && frame_results[:ended]
    game_repository.end_game!(game: game) if final_frame? && frame_results[:ended]
  end

  private

  attr_reader :game, :bowl, :current_frame, :frame_repository, :game_repository, :previous_throw

  def new_frame_results
    if strike?
      { points: 10, strike: true, ended: !final_frame?, bonus_throws: 2 }
    elsif spare?
      { points: 10, spare: true, ended: !final_frame?, bonus_throws: 1 }
    elsif first_throw?
      { points: bowl.points, ended: false }
    elsif final_frame?
      bonus_throws = current_frame.bonus_throws
      throws_left = bonus_throws.zero? ? 0 : bonus_throws - 1
      {
        points: current_frame.points + bowl.points,
        bonus_throws: throws_left,
        ended: throws_left.zero?
      }
    else
      { points: current_frame.points + bowl.points, ended: true }
    end
  end

  def final_frame?
    current_frame.number == 10
  end

  def first_throw?
    previous_throw.nil?
  end

  def strike?
    first_throw? && bowl.points == 10
  end

  def spare?
    !first_throw? && bowl.points + previous_throw.points == 10
  end

  def update_previous_frames_scores
    frame_repository.update_previous_frames_scores!(
      game_id: game.id,
      frame_number: current_frame.number,
      points: bowl.points
    )
  end

  def create_new_frame
    frame_repository.create!(game_id: game.id, number: current_frame.number + 1)
  end
end
