# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddGameThrow do
  let(:throw_repository) { class_double('ThrowRepository') }
  let(:update_game_interactor) { class_double('UpdateGameStatus') }
  let(:update_game_status) { instance_double('UpdateGameStatus') }
  let(:game) { instance_double('Game') }
  let(:frame) { instance_double('Frame') }
  let(:throw) { instance_double('Throw') }
  let(:knocked_pins) { 7 }
  let(:throw_count) { 3 }

  subject do
    described_class.new(
      game: game,
      frame: frame,
      throw_repository: throw_repository,
      update_game_interactor: update_game_interactor,
      knocked_pins: knocked_pins
    )
  end

  describe('#call') do
    before do
      allow(throw_repository).to receive(:create!).and_return(throw)
      allow(update_game_interactor).to receive(:new).and_return(update_game_status)
      allow(update_game_status).to receive(:call)
      allow(frame).to receive_message_chain(:throws, :count).and_return(throw_count)
    end

    it 'creates a new frame' do
      subject.call

      expect(throw_repository).to have_received(:create!).with(
        game: game,
        frame: frame,
        points: knocked_pins,
        number: throw_count + 1
      )
    end

    it 'calls the update game interactor' do
      subject.call

      expect(update_game_interactor).to have_received(:new).with(
        game: game,
        throw: throw,
        current_frame: frame
      )
      expect(update_game_status).to have_received(:call)
    end

    it 'returns the new throw' do
      result = subject.call

      expect(result).to eq throw
    end
  end
end
