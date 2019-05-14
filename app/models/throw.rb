# frozen_string_literal: true

class Throw < ApplicationRecord
  belongs_to :frame
  belongs_to :game

  validates_inclusion_of :points, in: 0..10
  validates_inclusion_of :number, in: 1..3
  validates_uniqueness_of :number, scope: [:frame_id]
end
