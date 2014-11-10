require "spec_helper"

describe "RPI calculator" do
  context "default" do
    it "calculates the RPI" do
      teams = []
      games = []
      rpi = CrashingTheDance::RpiCalculator.calculate teams, games

      expect(teams.size).to eql(teams.size)
    end

    it "returns your custom team attributes" do
      id = 1
      teams = teams_fixture 'single', id
      games = []
      rpi = CrashingTheDance::RpiCalculator.calculate teams, games

      expect(teams.first.id).to eql(id)
    end
  end

  context "no games played" do
    # do this and clean up the code
    before(:each) do
      @teams = teams_fixture 'palm'
      games = []
      @rpi = CrashingTheDance::RpiCalculator.calculate @teams, games
    end

    it "calculates the right number of teams" do
      expect(@rpi.size).to eql(@teams.size)
    end

    it "calculates the right win/loss record" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.wins).to eq(0)
      expect(valpo.losses).to eq(0)
      expect(valpo.win_percentage).to be_within(0.0001).of(0.0000)
    end

    it "calculates the RPI OWP" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.owp).to be_within(0.0001).of(0.0)
    end

    it "calculates the RPI OOWP" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.oowp).to be_within(0.0001).of(0.0)
    end

    it "calculates the RPI" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.rpi).to be_within(0.0001).of(0.0)
    end
  end

  # This comes from Jerry Palm's example RPI scenario at
  # http://www.collegerpi.com/subs/rpifaq.html
  context "the Palm scenario" do
    before(:each) do
      @teams = teams_fixture 'palm'
      games = games_fixture 'palm'
      @rpi = CrashingTheDance::RpiCalculator.calculate @teams, games
    end

    it "calculates the right win/loss record" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.wins).to eq(2)
      expect(valpo.losses).to eq(1)
      expect(valpo.win_percentage).to be_within(0.0001).of(0.6667)
    end

    it "calculates the RPI win/loss record" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.rpi_wins).to be_within(0.0001).of(2.0)
      expect(valpo.rpi_losses).to be_within(0.0001).of(0.6)
      expect(valpo.rpi_win_percentage).to be_within(0.0001).of(0.7692)
    end

    it "calculates the RPI OWP" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.owp).to be_within(0.0001).of(0.4444)
    end

    it "calculates the RPI OOWP" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.oowp).to be_within(0.0001).of(0.6528)
    end

    it "calculates the RPI" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.rpi).to be_within(0.0001).of(0.5777)
    end
  end

  context "full season" do
  end
end
