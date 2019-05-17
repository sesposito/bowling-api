# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::ThrowsController, type: :request do
  let(:game_id) { 13 }
  let(:frame_id) { 7 }
  let(:game) { instance_double('Game', id: game_id, current_frame_number: frame_id, ended: false) }
  let(:throw1_data) { { number: 1, points: 3 } }
  let(:throw2_data) { { number: 2, points: 5 } }
  let(:throw1) { instance_double('Throw', throw1_data) }
  let(:throw2) { instance_double('Throw', throw2_data) }
  let(:throws) { [throw1, throw2] }

  describe 'GET index' do
    before { allow(ThrowRepository).to receive(:list_throws).and_return(throws) }

    it 'returns the existing throws data' do
      get api_game_frame_throws_path(game_id, frame_id)

      expected_results = [
        throw1_data.tap { |t| t[:id] = t.delete(:number) },
        throw2_data.tap { |t| t[:id] = t.delete(:number) }
      ].map(&:stringify_keys)

      expect(JSON.parse(response.body).fetch('throws')).to include(*expected_results)
    end

    it 'returns a 200' do
      get api_game_frame_throws_path(game_id, frame_id)

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET resource' do
    describe 'when the resource exists' do
      before { allow(ThrowRepository).to receive(:find_throw).and_return(throw2) }

      it 'returns the existing throw data' do
        get api_game_frame_throw_path(game_id, frame_id, 2)

        expected_result = throw2_data.tap { |t| t[:id] = t.delete(:number) }.stringify_keys

        expect(JSON.parse(response.body)).to include(expected_result)
      end

      it 'returns a 200' do
        get api_game_frame_throw_path(game_id, frame_id, 2)

        expect(response).to have_http_status(:ok)
      end
    end

    describe 'when the resource does not exist' do
      before { allow(ThrowRepository).to receive(:find_throw).and_return(nil) }

      it 'returns a 404' do
        get api_game_frame_throw_path(game_id, frame_id, 2)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST resource' do
    let(:add_game_throw) { instance_double('AddGameThrow') }

    before do
      allow(GameRepository).to receive(:find_game_by_id).and_return(game)
      allow(add_game_throw).to receive(:call).and_return(throw1)
      allow(AddGameThrow).to receive(:new).and_return(add_game_throw)
    end

    context 'when the data is well formed' do
      let(:payload) { { knocked_pins: 4 } }

      it 'creates a new throw' do
        post api_game_frame_throws_path(game_id, frame_id), as: :json, params: payload

        expect(AddGameThrow).to have_received(:new).with(game: game, knocked_pins: 4)
        expect(add_game_throw).to have_received(:call)
      end

      it 'returns the new resource' do
        post api_game_frame_throws_path(game_id, frame_id), as: :json, params: payload

        expected_result = throw1_data.tap { |t| t[:id] = t.delete(:number) }.stringify_keys

        expect(JSON.parse(response.body)).to include(expected_result)
      end

      it 'returns a 200' do
        post api_game_frame_throws_path(game_id, frame_id), as: :json, params: payload

        expect(response).to have_http_status(:created)
      end
    end

    context 'when the data is semantically incorrect' do
      context 'the knocked_pins key is missing from the request body' do
        let(:payload) { { some_invalid_key: 'Foo' } }

        it 'returns a 422' do
          post api_game_frame_throws_path(game_id, frame_id), as: :json, params: payload

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'the knocked_pins value is invalid' do
        let(:payload) { { knocked_pins: 981 } }

        it 'returns a 422' do
          post api_game_frame_throws_path(game_id, frame_id), as: :json, params: payload

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
