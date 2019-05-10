# frozen_string_literal: true

class UpdateGameStatus
  def initialize(
    game:, bowl:,
    current_frame: nil,
    frame_repository: Frame,
    throw_repository: Throw
  )
    @game = game
    @bowl = bowl
    @current_frame = current_frame || game.current_frame
    @frame_repository = frame_repository
    @throw_repository = throw_repository
  end

  def call
    frame_results = new_frame_results
    current_frame.update!(frame_results)
    update_bonus_throws
    create_new_frame if !final_frame? && frame_results[:ended]
    game.update!(ended: true) if final_frame? && frame_results[:ended]
    game.reload
  end

  private

  attr_reader :game, :bowl, :current_frame, :frame_repository, :throw_repository

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

  def previous_throw
    @previous_throw ||= throw_repository.find_by(
      frame: current_frame,
      number: bowl.number - 1
    )
  end

  def strike?
    first_throw? && bowl.points == 10
  end

  def spare?
    !first_throw? && bowl.points + previous_throw.points == 10
  end

  def update_bonus_throws
    frame_repository
      .where(game: game)
      .where('bonus_throws > ?', 0)
      .where('number < ?', current_frame.number).each do |frame|
        frame.update!(
          points: frame.points + bowl.points,
          bonus_throws: frame.bonus_throws - 1
        )
      end
  end

  def create_new_frame
    frame_repository.create!(number: current_frame.number + 1, game: game)
  end
end
