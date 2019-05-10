# frozen_string_literal: true

class Frame < ApplicationRecord
  belongs_to :game
  has_many :rolls, dependent: :destroy

  validates_inclusion_of :points, in: 0..30
  validates_inclusion_of :number, in: 0..10

  def last_roll
    rolls.order(:number).last
  end
end
