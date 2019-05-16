# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Throw, type: :model do
  let(:game) { Game.new }
  let(:frame) { Frame.new(game: game, number: 1) }

  subject { described_class.new(game: game, frame: frame, number: 1, points: 3) }

  it 'is invalid if game is missing' do
    subject.game = nil

    expect(subject).to_not be_valid
  end

  it 'is invalid if frame is missing' do
    subject.frame = nil

    expect(subject).to_not be_valid
  end

  it 'is invalid if points is not in 0..10' do
    subject.points = 11

    expect(subject).to_not be_valid
  end

  it 'is invalid if number is not between 1..3' do
    subject.number = 4

    expect(subject).to_not be_valid
  end

  it 'is invalid if number is not unique within frame' do
    Throw.create!(game: game, frame: frame, number: 1, points: 2)

    expect(subject).to_not be_valid
  end

  it 'is valid with the correct params' do
    expect(subject).to be_valid
  end
end
