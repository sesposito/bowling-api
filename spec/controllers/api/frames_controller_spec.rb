# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::FramesController, type: :request do
  let(:game_id) { '6' }
  let(:throw_data) { { points: 3, number: 8 } }
  let(:throws) { (1..2).map { instance_double('Throw', throw_data) } }
  let(:frame_data) do
    {
      number: 1,
      points: 13,
      strike: true,
      spare: false,
      ended: true,
      bonus_throws: 1,
      throws: throws
    }
  end
  let(:frame) { instance_double('Frame', frame_data) }
  let(:frames) { [frame, frame] }

  describe 'GET index' do
    before { allow(FrameRepository).to receive(:list_frames).and_return(frames) }

    it 'returns the existing frames data' do
      get api_game_frames_path(game_id)

      expected_throw_data = (1..2).map do
        {
          id: throw_data[:number],
          points: throw_data[:points]
        }.stringify_keys
      end
      expected_result = (1..2).map do
        {
          id: frame_data[:number],
          points: frame_data[:points],
          strike: frame_data[:strike],
          spare: frame_data[:spare],
          ended: frame_data[:ended],
          throws: expected_throw_data
        }.stringify_keys
      end

      expect(FrameRepository).to have_received(:list_frames).with(game_id: game_id)
      expect(JSON.parse(response.body).fetch('frames')).to include(*expected_result)
    end

    it 'returns a 200' do
      get api_game_frames_path(game_id)

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET resource' do
    describe 'when the resource exists' do
      before { allow(FrameRepository).to receive(:find_frame).and_return(frame) }

      it 'returns the resource' do
        get api_game_frame_path(game_id, frame_data[:number])

        expected_throw_data = (1..2).map do
          {
            id: throw_data[:number],
            points: throw_data[:points]
          }.stringify_keys
        end
        expected_result = {
          id: frame_data[:number],
          points: frame_data[:points],
          strike: frame_data[:strike],
          spare: frame_data[:spare],
          ended: frame_data[:ended],
          throws: expected_throw_data
        }.stringify_keys

        expect(JSON.parse(response.body)).to include(expected_result)
      end

      it 'returns a 200' do
        get api_game_frame_path(game_id, frame_data[:number])

        expect(response).to have_http_status(:ok)
      end
    end

    describe 'when the resource does not exist' do
      before { allow(FrameRepository).to receive(:find_frame).and_return(nil) }

      it 'returns a 404' do
        get api_game_frame_path(game_id, frame_data[:number])

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
