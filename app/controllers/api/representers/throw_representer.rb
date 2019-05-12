# frozen_string_literal: true

module Api
  module Representers
    class ThrowRepresenter < Representable::Decorator
      include Representable::JSON

      property :number, as: :id
      property :points
    end
  end
end
