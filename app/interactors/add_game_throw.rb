# frozen_string_literal: true

class AddGameThrow
  def initialize(
    game:,
    knocked_pins:,
    throw_repository: ThrowRepository,
    update_game_interactor: UpdateGameStatus,
    frame: nil
  )
    @game = game
    @frame = frame || game.current_frame
    @knocked_pins = knocked_pins
    @update_game_interactor = update_game_interactor
    @throw_repository = throw_repository
  end

  def call
    new_throw = nil
    ActiveRecord::Base.transaction do
      new_throw = create_throw
      update_game_interactor.new(
        game: game,
        throw: new_throw,
        current_frame: frame
      ).call
    end

    new_throw
  end

  private

  attr_reader :game, :frame, :knocked_pins, :update_game_interactor, :throw_repository

  def create_throw
    throw_repository.create!(
      game: game,
      frame: frame,
      points: knocked_pins,
      number: frame.throws.count + 1
    )
  end
end
