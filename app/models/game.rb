# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :frames, dependent: :destroy

  validates :player_name, presence: true
end
