# frozen_string_literal: true

module Api
  module Representers
    class FrameRepresenter < Representable::Decorator
      include Representable::JSON

      property :number, as: :id
      property :strike
      property :spare
      property :points
      property :ended

      collection :throws, decorator: ThrowRepresenter, class: Throw
    end
  end
end
