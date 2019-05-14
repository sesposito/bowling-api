# frozen_string_literal: true

module Api
  class FramesController < ApiController
    def index
      frames = frames(params[:game_id])

      frames_representer = Representers::FramesRepresenter.new(frames)
      render(status: 200, json: frames_representer.to_json)
    end

    def show
      frame = find_frame!(params[:game_id], params[:id])
      frame_representer = Representers::FrameRepresenter.new(frame)
      render(status: 200, json: frame_representer.to_json)
    end

    private

    def frame_data(frame)
      Frame.new(
        number: frame.number,
        strike: frame.strike,
        spare: frame.spare,
        points: frame.points,
        throws: frame.throws,
        ended: frame.ended
      )
    end

    def frames(game_id)
      frames = FrameRepository.list_frames(game_id: game_id)
      Frames.new(
        frames: frames.map { |f| frame_data(f) },
        total_points: frames.sum(&:points)
      )
    end

    def find_frame!(game_id, frame_number)
      frame = FrameRepository.find_frame(game_id: game_id, frame_number: frame_number)
      raise Errors::NotFoundError, "Frame with id: #{frame_number} not found" unless frame

      frame
    end

    Frame = Struct.new(:number, :strike, :spare, :points, :ended, :throws, keyword_init: true)
    Frames = Struct.new(:frames, :total_points, keyword_init: true)
  end
end
