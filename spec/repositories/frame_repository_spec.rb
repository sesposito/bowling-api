# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FrameRepository do
  before do
    @game1 = Game.create!(player_name: 'player_1', current_frame_number: 1)
    @game2 = Game.create!(player_name: 'Player_2', current_frame_number: 2)
    @frame1 = Frame.create!(game: @game1, number: 1, points: 10, strike: true, bonus_throws: 2)
    @frame2 = Frame.create!(game: @game1, number: 2, points: 10, spare: true, bonus_throws: 1)
    @frame3 = Frame.create!(game: @game1, number: 3, points: 3, bonus_throws: 0)
    @frame4 = Frame.create!(game: @game1, number: 4, points: 4, bonus_throws: 1)
    @frame5 = Frame.create!(game: @game2, number: 8, points: 6)
  end

  subject { described_class }

  describe '.list_frames' do
    let(:game_id) { @game2.id }

    it 'returns the existing frames for a given game' do
      result = subject.list_frames(game_id: game_id)

      expect(result.size).to eq 1
      expect(result.first.id).to eq @frame5.id
    end
  end

  describe '.find_frame' do
    let(:game_id) { @game2.id }
    let(:frame_number) { @frame5.number }

    it 'returns the existing frame for the given game_id, frame_number' do
      result = subject.find_frame(game_id: game_id, frame_number: frame_number)

      expect(result.id).to eq @frame5.id
    end
  end

  describe '.update_previous_frames_scores!' do
    let(:game_id) { @game1.id }
    let(:frame_number) { @frame4.number }
    let(:points) { 5 }

    it 'adds points to all the previous frames with bonus throws' do
      subject.update_previous_frames_scores!(
        game_id: game_id,
        frame_number: frame_number,
        points: points
      )

      frame4_results = @frame4.reload.attributes.symbolize_keys.slice(:points, :bonus_throws)
      frame3_results = @frame3.reload.attributes.symbolize_keys.slice(:points, :bonus_throws)
      frame2_results = @frame2.reload.attributes.symbolize_keys.slice(:points, :bonus_throws)
      frame1_results = @frame1.reload.attributes.symbolize_keys.slice(:points, :bonus_throws)
      expect(frame4_results).to include(
        points: 4,
        bonus_throws: 1
      )
      expect(frame3_results).to include(
        points: 3,
        bonus_throws: 0
      )
      expect(frame2_results).to include(
        points: 15,
        bonus_throws: 0
      )
      expect(frame1_results).to include(
        points: 15,
        bonus_throws: 1
      )
    end
  end

  describe '.create!' do
    let(:game_id) { @game1.id }
    let(:number) { @frame4.number + 1 }

    it 'creates a new frame for the given game' do
      previous_frame_count = @game1.frames.count

      subject.create!(game_id: game_id, number: number)

      expect(@game1.frames.count).to eq previous_frame_count + 1
      expect(@game1.frames.max_by(&:number).number).to eq number
    end
  end

  describe '.update!' do
    let(:frame) { @frame5 }

    it 'updates the given frame with the attributes' do
      subject.update!(frame: frame, data: { points: 1, bonus_throws: 2 })

      frame.reload
      expect(frame.points).to eq 1
      expect(frame.bonus_throws).to eq 2
    end
  end
end
