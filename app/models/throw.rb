# frozen_string_literal: true

class Throw < ApplicationRecord
  belongs_to :frame

  validates_inclusion_of :points, in: 0..10
  validates_inclusion_of :number, in: 1..3
end
