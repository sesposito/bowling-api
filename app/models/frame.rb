# frozen_string_literal: true

class Frame < ApplicationRecord
  belongs_to :game
  has_many :throws, dependent: :destroy

  validates_inclusion_of :points, in: 0..30
  validates_inclusion_of :number, in: 0..10
  validates_uniqueness_of :number, scope: [:game_id]
  validates_presence_of :game
  validates :number, presence: true
  validate :strike_and_spare_are_mutually_exclusive

  def strike_and_spare_are_mutually_exclusive
    return if [spare, strike].none?

    errors.add(:strike_and_spare, 'must be mutually exclusive.') unless [strike, spare].one?
  end
end
