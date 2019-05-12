# frozen_string_literal: true

module GameLookup
  include ActiveSupport::Concern

  def find_game_by_id!(id)
    game = GameRepository.find_game_by_id(id)
    raise ::Api::Errors::NotFoundError, "Game with id: #{id} not found" unless game

    game
  end
end
