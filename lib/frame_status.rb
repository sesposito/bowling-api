# frozen_string_literal: true

class FrameStatus
  DEFAULTS = {
    points: 0,
    spare: false,
    strike: false,
    ended: false,
    bonus_throws: 0
  }.freeze

  def initialize(throw:, frame:)
    @throw = throw
    @frame = frame
  end

  def call
    DEFAULTS.merge(new_frame_results)
  end

  private

  attr_reader :throw, :frame

  def new_frame_results
    if strike?
      { points: 10, strike: true, ended: !final_frame?, bonus_throws: 2 }
    elsif spare?
      { points: 10, spare: true, ended: !final_frame?, bonus_throws: 1 }
    elsif first_throw?
      { points: throw.points, ended: false }
    elsif final_frame?
      bonus_throws = frame.bonus_throws
      throws_left = bonus_throws.zero? ? 0 : bonus_throws - 1
      {
        points: frame.points + throw.points,
        bonus_throws: throws_left,
        ended: throws_left.zero?
      }
    else
      { points: frame.points + throw.points, ended: true }
    end
  end

  def final_frame?
    frame.number == 10
  end

  def first_throw?
    throw.number == 1
  end

  def strike?
    first_throw? && throw.points == 10
  end

  def spare?
    throw.number == 2 && throw.points + previous_throw.points == 10
  end

  def previous_throw
    frame.throws.min_by(&:number)
  end
end
