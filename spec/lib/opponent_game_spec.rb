require 'spec_helper'

describe CrashingTheDance::RpiCalculator::OpponentGame do
  context "typical game" do
    before(:each) do
      @visitor = Team.new "Visitor"
      @home = Team.new "Home"
      @game = Game.new(@visitor, @home, 66, 77, nil)
    end

    context "visitor's perspective" do
      before(:each) do
        @wrapped = CrashingTheDance::RpiCalculator::OpponentGame.new @game, @visitor
      end
      it "gets the self team right" do
        expect(@wrapped.team).to eql(@visitor)
      end
      it "gets the self score right" do
        expect(@wrapped.score).to eql(@game.vis_score)
      end
      it "gets the opponent right" do
        expect(@wrapped.opponent).to eql(@home)
      end
      it "gets the opponent score right" do
        expect(@wrapped.opponent_score).to eql(@game.home_score)
      end
      it "gets the site right" do
        expect(@wrapped).not_to be_neutral
        expect(@wrapped).to be_visitor
        expect(@wrapped).not_to be_home
      end
      it "gets the win/loss right" do
        expect(@wrapped).to be_loss
        expect(@wrapped).not_to be_win
      end
      it "gets the RPI win/loss right" do
        expect(@wrapped.rpi_wins).to be_within(0.01).of(0.0)
        expect(@wrapped.rpi_losses).to be_within(0.01).of(0.6)
      end
    end

    context "home's perspective" do
      before(:each) do
        @wrapped = CrashingTheDance::RpiCalculator::OpponentGame.new @game, @home
      end
      it "gets the self team right" do
        expect(@wrapped.team).to eql(@home)
      end
      it "gets the self score right" do
        expect(@wrapped.score).to eql(@game.home_score)
      end
      it "gets the opponent right" do
        expect(@wrapped.opponent).to eql(@visitor)
      end
      it "gets the opponent score right" do
        expect(@wrapped.opponent_score).to eql(@game.vis_score)
      end
      it "gets the site right" do
        expect(@wrapped).not_to be_neutral
        expect(@wrapped).to be_home
        expect(@wrapped).not_to be_visitor
      end
      it "gets the win/loss right" do
        expect(@wrapped).to be_win
        expect(@wrapped).not_to be_loss
      end
      it "gets the RPI win/loss right" do
        expect(@wrapped.rpi_wins).to be_within(0.01).of(0.6)
        expect(@wrapped.rpi_losses).to be_within(0.01).of(0.0)
      end
    end

  end

  context "neutral game scenarios" do
    before(:each) do
      @visitor = Team.new "Visitor"
      @home = Team.new "Home"
    end

    it "treats nil values as non-neutral" do
      game = Game.new(@visitor, @home, 66, 77, nil)
      wrapped = CrashingTheDance::RpiCalculator::OpponentGame.new game, @visitor
      expect(wrapped).not_to be_neutral
    end

    it "treats empty strings as non-neutral" do
      game = Game.new(@visitor, @home, 66, 77, '')
      wrapped = CrashingTheDance::RpiCalculator::OpponentGame.new game, @visitor
      expect(wrapped).not_to be_neutral
    end

    it "treats blank strings as non-neutral" do
      game = Game.new(@visitor, @home, 66, 77, ' ')
      wrapped = CrashingTheDance::RpiCalculator::OpponentGame.new game, @visitor
      expect(wrapped).not_to be_neutral
    end

    it "treats 'N' as neutral" do
      game = Game.new(@visitor, @home, 66, 77, 'N')
      wrapped = CrashingTheDance::RpiCalculator::OpponentGame.new game, @visitor
      expect(wrapped).to be_neutral
    end
  end

  context "neutral game RPI" do
    before(:each) do
      @visitor = Team.new "Visitor"
      @home = Team.new "Home"
      @game = Game.new(@visitor, @home, 66, 77, 'N')
    end

    it "gets the site right" do
      wrapped = CrashingTheDance::RpiCalculator::OpponentGame.new @game, @visitor
      expect(wrapped).to be_neutral
      expect(wrapped).not_to be_home
      expect(wrapped).not_to be_visitor
    end

    it "gets the loser RPI wins/loss right" do
      wrapped = CrashingTheDance::RpiCalculator::OpponentGame.new @game, @visitor
      expect(wrapped.rpi_wins).to be_within(0.01).of(0.0)
      expect(wrapped.rpi_losses).to be_within(0.01).of(1.0)
    end
    it "gets the winner RPI wins/loss right" do
      wrapped = CrashingTheDance::RpiCalculator::OpponentGame.new @game, @home
      expect(wrapped.rpi_wins).to be_within(0.01).of(1.0)
      expect(wrapped.rpi_losses).to be_within(0.01).of(0.0)
    end
  end
end

