# frozen_string_literal: true

class AddGameThrow
  def initialize(
    game:,
    frame: nil,
    knocked_pins:,
    throw_repository: Throw,
    update_game_interactor: UpdateGameStatus
  )
    @game = game
    @frame = frame || game.current_frame
    @knocked_pins = knocked_pins
    @update_game_interactor = update_game_interactor
    @throw_repository = throw_repository
  end

  def call
    raise 'Game already ended.' if game.ended

    ActiveRecord::Base.transaction do
      update_game_interactor.new(
        game: game,
        bowl: create_throw,
        current_frame: frame
      ).call
    end
  end

  private

  attr_reader :game, :frame, :knocked_pins, :previous_throw, :update_game_interactor,
              :throw_repository

  def first_throw?
    frame.previous_throw.nil?
  end

  def create_throw
    throw_repository.create!(
      frame: frame,
      points: knocked_pins,
      number: first_throw? ? 1 : frame.previous_throw.number + 1
    )
  end
end
