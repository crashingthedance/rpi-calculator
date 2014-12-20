require "crashing_the_dance/rpi_calculator/version"
require "crashing_the_dance/rpi_calculator/rpi"
require "crashing_the_dance/rpi_calculator/opponent_game"

module CrashingTheDance
  module RpiCalculator
    # teams should be valid hash keys (#hash and #eql?)
    # don't put any other requirements (e.g., #name)
    # also use fixtures to test them. simple, lightweight.
    def self.calculate(teams, games)
      by_team = games_by_team(teams, games)
      teams = build_rpi teams, by_team
      calculate_owp teams, by_team
      calculate_oowp teams
      calculate_conference_owp teams, by_team
      calculate_conference_oowp teams
      calculate_nonconference_owp teams, by_team
      calculate_nonconference_oowp teams
      teams
    end

    private

    def self.calculate_oowp(teams)
      teams.each do |team|
        team.calculate_oowp teams
      end
    end

    def self.calculate_owp(teams, games_by_team)
      teams.each do |team|
        team.calculate_owp(games_by_team)
      end
    end

    def self.calculate_conference_oowp(teams)
      teams.each do |team|
        team.calculate_conference_oowp teams
      end
    end

    def self.calculate_conference_owp(teams, games_by_team)
      teams.each do |team|
        team.calculate_conference_owp(games_by_team)
      end
    end

    def self.calculate_nonconference_oowp(teams)
      teams.each do |team|
        team.calculate_nonconference_oowp teams
      end
    end

    def self.calculate_nonconference_owp(teams, games_by_team)
      teams.each do |team|
        team.calculate_nonconference_owp(games_by_team)
      end
    end

    def self.build_rpi(teams, games_by_team)
      teams.map { |team| RPI.new team, games_by_team[team] }
    end

    def self.games_by_team(teams, games)
      all = teams.inject({}) { |a, team| a[team] = [ ]; a }
      games.each do |game|
        # has to be a cleaner way than this
        add_team_game all, game, game.vis_team
        add_team_game all, game, game.home_team
      end
      all
    end

    def self.add_team_game(all, game, team)
      all[team] << OpponentGame.new(game, team) if all.has_key?(team)
    end
  end
end
