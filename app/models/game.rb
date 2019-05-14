# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :frames, dependent: :destroy

  validates :player_name, presence: true
  validates :current_frame_number, presence: true

  def current_frame
    frames.find_by(number: current_frame_number)
  end
end
