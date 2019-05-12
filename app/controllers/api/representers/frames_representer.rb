# frozen_string_literal: true

module Api
  module Representers
    class FramesRepresenter < Representable::Decorator
      include Representable::JSON

      property :total_points
      collection :frames, decorator: FrameRepresenter, class: Frame
    end
  end
end
