# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Frame, type: :model do
  let(:game) { Game.new }

  subject { described_class.new(game: game, number: 1, strike: true, spare: false) }

  it 'is invalid if game_id is missing' do
    subject.number = nil

    expect(subject).to_not be_valid
  end

  it 'is invalid if number is missing' do
    subject.number = nil

    expect(subject).to_not be_valid
  end

  it 'is invalid if number is not between 0 and 10' do
    subject.number = 11

    expect(subject).to_not be_valid
  end

  it 'is invalid if number is not unique within a game' do
    Frame.create!(game: game, number: 1)

    expect(subject).to_not be_valid
  end

  it 'is invalid if points is not between 0 and 30' do
    subject.points = -1

    expect(subject).to_not be_valid
  end

  it 'is invalid if strike and spare are not mutually exclusive' do
    subject.spare = true

    expect(subject).to_not be_valid
  end

  it 'is valid with the correct params' do
    expect(subject).to be_valid
  end
end
