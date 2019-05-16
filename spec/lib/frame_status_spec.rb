# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FrameStatus do
  let(:throw)  { instance_double('Throw') }
  let(:frame_data) do
    {
      points: 0,
      number: 1,
      spare: false,
      strike: false,
      ended: false,
      bonus_throws: 0
    }
  end
  let(:frame) { instance_double('Frame', frame_data) }

  subject { described_class.new(throw: throw, frame: frame).call }

  context "when it's the first throw of a frame" do
    before { allow(throw).to receive(:number).and_return(1) }

    context "when it's a strike" do
      before { allow(throw).to receive(:points).and_return(10) }

      it { is_expected.to include(points: 10, strike: true, bonus_throws: 2) }

      context "when it's not the final frame" do
        before { allow(frame).to receive(:number).and_return(3) }

        it { is_expected.to include(ended: true) }
      end

      context "when it's the final frame" do
        before { allow(frame).to receive(:number).and_return(10) }

        it { is_expected.to include(ended: false) }
      end
    end

    context "when it's not a strike" do
      before { allow(throw).to receive(:points).and_return(3) }

      it { is_expected.to include(points: 3, ended: false) }
    end
  end

  context "when it's not the first throw of a frame" do
    let(:previous_throw) { instance_double('Throw', points: 8) }

    before do
      allow(throw).to receive(:number).and_return(2)
      allow(throw).to receive(:points).and_return(2)
      allow(frame).to receive_message_chain(:throws, :min_by).and_return(previous_throw)
    end

    context "when it's a spare" do
      it { is_expected.to include(points: 10, spare: true, bonus_throws: 1) }

      context "when it's the last frame" do
        before { allow(frame).to receive(:number).and_return(10) }

        it { is_expected.to include(ended: false) }
      end

      context "when it's not the last frame" do
        before { allow(frame).to receive(:number).and_return(4) }

        it { is_expected.to include(ended: true) }
      end
    end

    context "when it's the last frame" do
      before do
        allow(frame).to receive(:number).and_return(10)
        allow(frame).to receive(:points).and_return(10)
        allow(frame).to receive(:bonus_throws).and_return(1)
        allow(throw).to receive(:points).and_return(4)
      end

      it { is_expected.to include(points: 10 + 4) }

      context 'when the frame has bonus throws left' do
        before { allow(frame).to receive(:bonus_throws).and_return(2) }

        it { is_expected.to include(ended: false, bonus_throws: 1) }
      end

      context 'when the frame has no bonus throws left' do
        before { allow(frame).to receive(:bonus_throws).and_return(0) }

        it { is_expected.to include(ended: true, bonus_throws: 0) }
      end

      context 'when the frame is a strike' do
        before { allow(frame).to receive(:strike).and_return(true) }

        it { is_expected.to include(strike: true) }
      end
    end

    context "when it's not the last frame" do
      before do
        allow(frame).to receive(:number).and_return(4)
        allow(frame).to receive(:points).and_return(3)
        allow(throw).to receive(:points).and_return(5)
      end

      it { is_expected.to include(points: 8, ended: true) }
    end
  end
end
