# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateGameStatus do
  let(:game_id) { 3 }
  let(:frame_number) { 4 }
  let(:throw_points) { 6 }
  let(:game) { instance_double('Game', id: game_id) }
  let(:throw) { instance_double('Throw', points: throw_points) }
  let(:frame) { instance_double('Frame', number: frame_number) }
  let(:frame_repository) { class_double('FrameRepository') }
  let(:game_repository) { class_double('GameRepository') }
  let(:frame_status_class) { class_double('FrameStatus') }
  let(:frame_status) { instance_double('FrameStatus') }
  let(:frame_results) { double('OpenStruct', ended: false) }

  subject do
    described_class.new(
      game: game,
      throw: throw,
      current_frame: frame,
      frame_repository: frame_repository,
      game_repository: game_repository,
      frame_status_class: frame_status_class
    )
  end

  describe('#call') do
    before do
      allow(frame_status_class).to receive(:new).and_return(frame_status)
      allow(frame_status).to receive(:call).and_return(frame_results)
      allow(frame_repository).to receive(:create!)
      allow(frame_repository).to receive(:update!)
      allow(frame_repository).to receive(:update_previous_frames_scores!)
      allow(game_repository).to receive(:end_game!)
      allow(game_repository).to receive(:update_current_frame_number!)
    end

    it 'updates the frame with the results of the throw' do
      subject.call

      expect(frame_status_class).to have_received(:new).with(
        frame: frame,
        throw: throw
      )
      expect(frame_status).to have_received(:call)
      expect(frame_repository).to have_received(:update!).with(
        frame: frame,
        data: frame_results
      )
    end

    it 'updates the frames with bonus throws' do
      subject.call

      expect(frame_repository).to have_received(:update_previous_frames_scores!).with(
        game_id: game_id,
        frame_number: frame_number,
        points: throw_points
      )
    end

    context 'when the frame is the final one of the game' do
      let(:frame) { instance_double('Frame', number: 10) }

      context 'when the frame has ended' do
        let(:frame_results) { double('OpenStruct', ended: true) }

        it 'ends the game' do
          subject.call

          expect(game_repository).to have_received(:end_game!).with(game: game)
        end
      end
    end

    context 'when the frame is not the final one of the game' do
      let(:frame) { instance_double('Frame', number: 3) }

      context 'when the frame has ended' do
        let(:frame_results) { double('OpenStruct', ended: true) }

        it 'creates a new frame' do
          subject.call

          expect(game_repository).to have_received(:update_current_frame_number!).with(
            game: game,
            number: 4
          )
          expect(frame_repository).to have_received(:create!).with(
            game_id: game_id,
            number: 4
          )
        end
      end
    end
  end
end
