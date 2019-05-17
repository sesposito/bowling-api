# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameRepository do
  before do
    @game1 = Game.create!(player_name: 'player_1', current_frame_number: 1)
    @game2 = Game.create!(player_name: 'Player_2', current_frame_number: 2)
  end

  subject { described_class }

  describe '.list_games' do
    it 'returns the existing games' do
      result = subject.list_games

      expect(result.size).to eq 2
      expect(result.min_by(&:id).id).to eq @game1.id
      expect(result.max_by(&:id).id).to eq @game2.id
    end
  end

  describe '.find_game_by_id' do
    let(:game_id) { @game2.id }

    it 'returns and existing game by its id' do
      expect(subject.find_game_by_id(game_id).id).to eq @game2.id
    end
  end

  describe '.create!' do
    let(:player_name) { 'Simon' }

    it 'creates a new game with the correct attributes' do
      previous_game_count = Game.count

      subject.create!(player_name: player_name)

      expect(Game.count).to eq previous_game_count + 1
      expect(Game.order(:id).last.player_name).to eq player_name
      expect(Game.order(:id).last.current_frame_number).to eq 1
    end

    it 'returns the created game' do
      result = subject.create!(player_name: player_name)

      expect(result.id).to eq Game.order(:id).last.id
    end
  end

  describe '.update_current_frame_number!' do
    let(:game) { @game2 }
    let(:current_frame_number) { 2 }

    it 'updates a given game current frame number' do
      subject.update_current_frame_number!(game: game, number: current_frame_number)

      expect(@game2.reload.current_frame_number).to eq current_frame_number
    end
  end

  describe '.end_game!' do
    let(:game) { @game2 }

    it 'updates a given game to be ended' do
      subject.end_game!(game: game)

      expect(@game2.reload.ended).to be true
    end
  end

  describe '.destroy!' do
    let(:game) { @game2 }

    it 'destroys the given game' do
      subject.destroy!(game: game)

      expect(Game.find_by(id: game.id)).to be_nil
    end
  end
end
