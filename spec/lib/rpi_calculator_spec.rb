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

  context "one game played" do
    before(:each) do
      @teams = teams_fixture 'onegame'
      games = games_fixture 'onegame'
      @rpi = CrashingTheDance::RpiCalculator.calculate @teams, games
    end

    it "calculates the right win/loss record" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.wins).to eq(1)
      expect(valpo.losses).to eq(0)
      expect(valpo.win_percentage).to be_within(0.0001).of(1.0000)
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
      # since OWP/OOWP is 0, RPI is 0.25
      expect(valpo.rpi).to be_within(0.0001).of(0.2500)
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

    it "calculates the right conference win/loss record" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.wins_conference).to eq(0)
      expect(valpo.losses_conference).to eq(0)
    end

    it "calculates the right nonconference win/loss record" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.wins_nonconference).to eq(0)
      expect(valpo.losses_nonconference).to eq(0)
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

    it "calculates the conference RPI" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.rpi_conference).to be_within(0.0001).of(0.0)
    end

    it "calculates the nonconference RPI" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.rpi_nonconference).to be_within(0.0001).of(0.0)
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

    it "calculates the right conference win/loss record" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.wins_conference).to eq(0)
      expect(valpo.losses_conference).to eq(0)
    end

    it "calculates the right non-conference win/loss record" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.wins_nonconference).to eq(2)
      expect(valpo.losses_nonconference).to eq(1)
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

  # the same as the Palm scenario with all Valpo games as conference games
  # using all games will make it easier to verify ground truth
  context "the Palm scenario as conference" do
    before(:each) do
      @teams = teams_fixture 'palm-conference'
      games = games_fixture 'palm-conference'
      @rpi = CrashingTheDance::RpiCalculator.calculate @teams, games
    end

    it "calculates the right conference win/loss record" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.wins_conference).to eq(2)
      expect(valpo.losses_conference).to eq(1)
    end

    it "calculates the conference RPI win/loss record" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.rpi_wins_conference).to be_within(0.0001).of(2.0)
      expect(valpo.rpi_losses_conference).to be_within(0.0001).of(0.6)
    end

    it "calculates the conference RPI" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.rpi_conference).to be_within(0.0001).of(0.5777)
    end

    it "calculates the nonconference RPI" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.rpi_nonconference).to be_within(0.0001).of(0.0000)
    end

    it "calculates the right non-conference win/loss record" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.wins_nonconference).to eq(0)
      expect(valpo.losses_nonconference).to eq(0)
    end

    it "calculates the non-conference RPI win/loss record" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.rpi_wins_nonconference).to be_within(0.0001).of(0.0)
      expect(valpo.rpi_losses_nonconference).to be_within(0.0001).of(0.0)
    end

    it "calculates the conference RPI OWP" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.owp_conference).to be_within(0.0001).of(0.4444)
    end

    it "calculates the conference RPI OOWP" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.oowp_conference).to be_within(0.0001).of(0.6528)
    end

    it "calculates the non-conference RPI OWP" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.owp_nonconference).to be_within(0.0001).of(0.0000)
    end

    it "calculates the nonconference RPI OOWP" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.oowp_nonconference).to be_within(0.0001).of(0.0000)
    end
  end

  # the same as the Palm scenario with all Valpo games as conference games
  # using all games will make it easier to verify ground truth
  context "the Palm scenario as nonconference" do
    before(:each) do
      @teams = teams_fixture 'palm-nonconference'
      games = games_fixture 'palm-nonconference'
      @rpi = CrashingTheDance::RpiCalculator.calculate @teams, games
    end

    it "calculates the right nonconference win/loss record" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.wins_nonconference).to eq(2)
      expect(valpo.losses_nonconference).to eq(1)
    end

    it "calculates the nonconference RPI win/loss record" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.rpi_wins_nonconference).to be_within(0.0001).of(2.0)
      expect(valpo.rpi_losses_nonconference).to be_within(0.0001).of(0.6)
    end

    it "calculates the nonconference RPI" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.rpi_nonconference).to be_within(0.0001).of(0.5777)
    end

    it "calculates the conference RPI" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.rpi_conference).to be_within(0.0001).of(0.0000)
    end

    it "calculates the right conference win/loss record" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.wins_conference).to eq(0)
      expect(valpo.losses_conference).to eq(0)
    end

    it "calculates the conference RPI win/loss record" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.rpi_wins_conference).to be_within(0.0001).of(0.0)
      expect(valpo.rpi_losses_conference).to be_within(0.0001).of(0.0)
    end

    it "calculates the nonconference RPI OWP" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.owp_nonconference).to be_within(0.0001).of(0.4444)
    end

    it "calculates the nonconference RPI OOWP" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.oowp_nonconference).to be_within(0.0001).of(0.6528)
    end

    it "calculates the conference RPI OWP" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.owp_conference).to be_within(0.0001).of(0.0000)
    end

    it "calculates the conference RPI OOWP" do
      valpo = @rpi.find { |team| team.team.name.eql? "Valparaiso" }
      expect(valpo.oowp_conference).to be_within(0.0001).of(0.0000)
    end
  end

  context "full season" do
  end
end
