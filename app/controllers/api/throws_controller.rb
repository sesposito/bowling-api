# frozen_string_literal: true

module Api
  class ThrowsController < ApiController
    include GameLookup

    def index
      throws = throws(params[:game_id], params[:frame_id])
      throws_representer = Representers::ThrowsRepresenter.new(throws)
      render(status: 200, json: throws_representer.to_json)
    end

    def show
      frame_throw = find_throw!(
        params[:game_id],
        params[:frame_id],
        params[:id]
      )

      throw_representer = Representers::ThrowRepresenter.new(throw_data(frame_throw))
      render(status: 200, json: throw_representer.to_json)
    end

    def create
      game = find_game_by_id!(params[:game_id])
      frame_id = params[:frame_id].to_i

      raise Errors::ValidationError, 'Game already finished' if game.ended
      raise Errors::ValidationError, "Invalid frame: #{params[:frame_id]}" unless valid_frame?(game, frame_id)

      data = { game: game }.merge(parse_body!)
      new_throw = AddGameThrow.new(data).call

      throw_representer = Representers::ThrowRepresenter.new(throw_data(new_throw))
      render(status: 201, json: throw_representer.to_json)
    end

    private

    def throws(game_id, frame_id)
      frame_throws = ThrowsRepository.list_throws(game_id: game_id, frame_number: frame_id)
      Rails.logger.info(frame_throws)
      Throws.new(throws: frame_throws.map { |t| throw_data(t) })
    end

    def throw_data(throw)
      Throw.new(
        number: throw.number,
        points: throw.points
      )
    end

    def find_throw!(game_id, frame_number, throw_number)
      frame_throw = ThrowsRepository.find_frame_throw(
        game_id: game_id,
        frame_number: frame_number,
        throw_number: throw_number
      )

      raise Errors::NotFoundError, "Frame: #{frame_id} throw  number: #{throw_number} not found" unless frame_throw

      frame_throw
    end

    def parse_body!
      body = JSON.parse(request.body.read).symbolize_keys
      points = body[:knocked_pins].to_i

      raise Errors::ValidationError, 'Missing "knocked_pins" key' unless body.key?(:knocked_pins)
      raise Errors::ValidationError, '"knocked_pins" must be an integer {1..10}' unless (1..10).include?(points)

      { knocked_pins: points }
    rescue JSON::ParserError
      raise Errors::ValidationError, 'Invalid JSON'
    end

    def valid_frame?(game, frame_id)
      game.current_frame.number == frame_id.to_i
    end

    Throw = Struct.new(:number, :points, keyword_init: true)
    Throws = Struct.new(:throws, keyword_init: true)
  end
end
