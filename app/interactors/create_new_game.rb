# frozen_string_literal: true

class CreateNewGame
  def initialize(player_name:, game_repository: GameRepository, frame_repository: FrameRepository)
    @player_name = player_name
    @game_repository = game_repository
    @frame_repository = frame_repository
  end

  def call
    new_game = game_repository.create!(player_name: player_name)
    frame_repository.create!(game_id: new_game.id, number: 1)
    new_game
  end

  private

  attr_reader :player_name, :game_repository, :frame_repository
end
