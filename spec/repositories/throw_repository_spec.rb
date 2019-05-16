# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ThrowRepository do
  before do
    @game1 = Game.create!(player_name: 'player_1', current_frame_number: 1)
    @game2 = Game.create!(player_name: 'Player_2', current_frame_number: 2)
    @frame1 = Frame.create!(game: @game1, number: 1)
    @frame2 = Frame.create!(game: @game2, number: 1)
    @throw1 = Throw.create!(game: @game1, frame: @frame1, number: 1, points: 4)
    @throw2 = Throw.create!(game: @game2, frame: @frame2, number: 1, points: 7)
  end

  subject { described_class }

  describe '.list_throws' do
    let(:game_id) { @game1.id }
    let(:frame_number) { @frame1.number }

    it 'returns the existing throws for a given game and frame' do
      result = subject.list_throws(game_id: game_id, frame_number: frame_number)

      expect(result.size).to eq 1
      expect(result.first.id).to eq @throw1.id
    end
  end

  describe '.find_throw' do
    let(:game_id) { @game2.id }
    let(:frame_number) { @frame2.number }
    let(:throw_number) { @throw2.number }

    it 'returns a throw for a given game, frame and throw number' do
      result = subject.find_throw(
        game_id: game_id,
        frame_number: frame_number,
        throw_number: throw_number
      )

      expect(result.id).to eq @throw2.id
    end
  end
end
