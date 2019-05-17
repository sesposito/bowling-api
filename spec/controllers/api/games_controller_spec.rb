# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::GamesController, type: :request do
  let(:game1_frames) { [instance_double('Frame', points: 3)] }
  let(:game2_frames) { (1..10).map { instance_double('Frame', points: 30) } }
  let(:game1_data) { { id: 1, player_name: 'Foo', current_frame_number: 1, ended: false } }
  let(:game2_data) { { id: 2, player_name: 'Bar', current_frame_number: 10, ended: true } }
  let(:game1) { instance_double('Game', game1_data.merge(frames: game1_frames)) }
  let(:game2) { instance_double('Game', game2_data.merge(frames: game2_frames)) }
  let(:games) { [game1, game2] }

  describe 'GET index' do
    before { allow(GameRepository).to receive(:list_games).and_return(games) }

    it 'returns the existing games data' do
      get api_games_path

      expected_result = [
        game1_data.merge(total_points: 3).tap { |h| h[:current_frame] = h.delete(:current_frame_number) },
        game2_data.merge(total_points: 300).tap { |h| h[:current_frame] = h.delete(:current_frame_number) }
      ].map(&:stringify_keys)

      expect(JSON.parse(response.body).fetch('games')).to include(*expected_result)
    end

    it 'returns a 200' do
      get api_games_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET resource' do
    context 'when the resource exists' do
      before { allow(GameRepository).to receive(:find_game_by_id).and_return(game2) }

      it 'returns the existing game data' do
        get api_game_path(2)

        expected_result = game2_data.merge(total_points: 300)
                                    .tap { |h| h[:current_frame] = h.delete(:current_frame_number) }
                                    .stringify_keys

        expect(JSON.parse(response.body)).to include(expected_result)
      end

      it 'returns a 200' do
        get api_game_path(2)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the resource does not exist' do
      before { allow(GameRepository).to receive(:find_game_by_id).and_return(nil) }

      it 'returns a 404' do
        get api_game_path(2)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST resource' do
    let(:create_new_game) { instance_double('CreateNewGame') }

    before do
      allow(create_new_game).to receive(:call).and_return(game1)
      allow(CreateNewGame).to receive(:new).and_return(create_new_game)
    end

    context 'when the data is well formed' do
      let(:payload) { { player_name: 'Foo' } }

      it 'creates a new game' do
        post api_games_path, as: :json, params: payload

        expect(CreateNewGame).to have_received(:new).with(player_name: 'Foo')
        expect(create_new_game).to have_received(:call)
      end

      it 'returns the new resource' do
        post api_games_path, as: :json, params: payload

        expected_result = game1_data.merge(total_points: 3)
                                    .tap { |h| h[:current_frame] = h.delete(:current_frame_number) }
                                    .stringify_keys

        expect(JSON.parse(response.body)).to include(expected_result)
      end

      it 'returns a 200' do
        post api_games_path, as: :json, params: payload

        expect(response).to have_http_status(:created)
      end
    end

    context 'when the data is semantically incorrect' do
      let(:payload) { { some_invalid_key: 'Foo' } }

      it 'returns a 422' do
        post api_games_path, as: :json, params: payload

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE resource' do
    before do
      allow(GameRepository).to receive(:find_game_by_id).and_return(game1)
      allow(GameRepository).to receive(:destroy!)
    end

    it 'destroys the resource' do
      delete api_game_path(1)

      expect(GameRepository).to have_received(:destroy!).with(game: game1)
    end

    it 'returns deleted status code' do
      delete api_game_path(1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
