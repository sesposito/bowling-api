# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameLookup do
  let(:game_id) { 3 }
  let(:game) { instance_double('Game') }

  subject { Class.new { include GameLookup }.new }

  describe '.find_game_by_id!' do
    context 'when the game exists' do
      before { allow(GameRepository).to receive(:find_game_by_id).and_return(game) }

      it 'returns the game when it exists' do
        result = subject.find_game_by_id!(game_id)

        expect(GameRepository).to have_received(:find_game_by_id).with(game_id)
        expect(result).to eq game
      end
    end

    context 'when the game does not exist' do
      before { allow(GameRepository).to receive(:find_game_by_id).and_return(nil) }

      it 'raises a NotFoundError' do
        expect { subject.find_game_by_id!(game_id) }.to raise_error(Api::Errors::NotFoundError)
      end
    end
  end
end
