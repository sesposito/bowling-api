# frozen_string_literal: true

class CreateNewGame
  def initialize(player_name:, game_repository: Game, frame_repository: Frame)
    @player_name = player_name
    @game_repository = game_repository
    @frame_repository = frame_repository
  end

  def call
    new_game = game_repository.create!(player_name: player_name)
    frame_repository.create!(game: new_game, number: 1)
    new_game
  end

  private

  attr_reader :player_name, :game_repository, :frame_repository
end
