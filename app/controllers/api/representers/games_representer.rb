# frozen_string_literal: true

module Api
  module Representers
    class GamesRepresenter < Representable::Decorator
      include Representable::JSON

      collection :games, decorator: GameRepresenter, class: Game
    end
  end
end
