# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  subject { described_class.new(player_name: 'Peter Griffin') }

  it 'is invalid if player_name is nil' do
    subject.player_name = nil

    expect(subject).to_not be_valid
  end

  it 'is invalid if player_name is ""' do
    subject.player_name = ''

    expect(subject).to_not be_valid
  end

  it 'is valid wiht the correct params' do
    expect(subject).to be_valid
  end
end
