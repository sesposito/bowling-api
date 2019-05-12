# frozen_string_literal: true

module Api
  module Representers
    class ThrowsRepresenter < Representable::Decorator
      include Representable::JSON

      collection :throws, decorator: ThrowRepresenter, class: Throw
    end
  end
end
