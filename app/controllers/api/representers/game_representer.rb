# frozen_string_literal: true

module Api
  module Representers
    class GameRepresenter < Representable::Decorator
      include Representable::JSON

      property :id
      property :player_name
      property :current_frame
      property :points
      property :ended
    end
  end
end
