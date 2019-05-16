# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateNewGame do
  let(:game_repository) { class_double('GameRepository') }
  let(:frame_repository) { class_double('FrameRepository') }
  let(:game_id) { 1 }
  let(:game) { instance_double('Game', id: game_id) }
  let(:player_name) { 'Player 1' }

  subject do
    described_class.new(
      player_name: player_name,
      frame_repository: frame_repository,
      game_repository: game_repository
    )
  end

  describe('#call') do
    before do
      allow(game_repository).to receive(:create!).and_return(game)
      allow(frame_repository).to receive(:create!)
    end

    it 'creates a new game' do
      subject.call

      expect(game_repository).to have_received(:create!).with(player_name: player_name)
    end

    it 'creates a new frame' do
      subject.call

      expect(frame_repository).to have_received(:create!).with(game_id: game_id, number: 1)
    end

    it 'returns the new game' do
      result = subject.call

      expect(result).to eq game
    end
  end
end
