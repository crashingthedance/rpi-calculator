module CrashingTheDance
  module RpiCalculator
    class RPI
      attr_reader :team,
                  :games, :games_conference, :games_nonconference,
                  :wins, :losses,
                  :rpi_wins, :rpi_losses,
                  :wins_conference, :losses_conference,
                  :rpi_wins_conference, :rpi_losses_conference,
                  :wins_nonconference, :losses_nonconference,
                  :rpi_wins_nonconference, :rpi_losses_nonconference

      def initialize(team, games)
        @team = team
        initialize_games(games)
        initialize_rpi
        calculate_record
      end

      def win_percentage
        if games.count > 0
          wins.to_f / (wins.to_f + losses.to_f)
        else
          0.0
        end
      end

      def rpi_win_percentage
        if games.count > 0
          rpi_wins / (rpi_wins + rpi_losses)
        else
          0.0
        end
      end

      def rpi_win_percentage_conference
        if games_conference.count > 0
          rpi_wins_conference / (rpi_wins_conference + rpi_losses_conference)
        else
          0.0
        end
      end

      def rpi_win_percentage_nonconference
        if games_nonconference.count > 0
          rpi_wins_nonconference / (rpi_wins_nonconference + rpi_losses_nonconference)
        else
          0.0
        end
      end

      def owp
        @owp
      end

      def oowp
        @oowp
      end

      def owp_conference
        @owp_conference
      end

      def oowp_conference
        @oowp_conference
      end

      def owp_nonconference
        @owp_nonconference
      end

      def oowp_nonconference
        @oowp_nonconference
      end

      def rpi
        @rpi ||= calculate_rpi
      end

      def rpi_conference
        @rpi_conference ||= calculate_rpi_conference
      end

      def rpi_nonconference
        @rpi_nonconference ||= calculate_rpi_nonconference
      end

      # To calculate opponent's winning percentage (OWP), you remove games against
      # the team in question.
      # However, for the purpose of calculating OWP and OOWP, use standard WP.
      def calculate_owp(games_by_team)
        if games.count > 0
          sum_owp = games.inject(0.0) do |sum, game|
            sked = opponent_schedule game.opponent, games_by_team
            ow = sked.inject(0) { |wins, og| wins + og.wins }
            sum + (sked.empty? ? 0.0 : (ow.to_f / sked.count.to_f))
          end
          @owp = sum_owp / games.count.to_f
        end
      end

      # Now to calculate the opponents' opponents winning percentage (OOWP),
      # you simply average the OWPs for each of their opponents.
      def calculate_oowp(all_teams)
        if games.count > 0
          sum_oowp = games.inject(0.0) do |sum, game|
            opponent = all_teams.find { |t| game.opponent.eql? t.team }
            sum + opponent.owp
          end
          @oowp = sum_oowp / games.count.to_f
        end
      end

      # hate this repitition but not yet sure how to consolidate
      # the logic is roughly the same, but they
      # set separate instance variables
      def calculate_conference_owp(games_by_team)
        if games_conference.count > 0
          sum_owp = games_conference.inject(0.0) do |sum, game|
            sked = opponent_schedule game.opponent, games_by_team
            ow = sked.inject(0) { |wins, og| wins + og.wins }
            sum + (sked.empty? ? 0.0 : (ow.to_f / sked.count.to_f))
          end
          @owp_conference = sum_owp / games_conference.count.to_f
        end
      end

      def calculate_conference_oowp(all_teams)
        if games_conference.count > 0
          sum_oowp = games_conference.inject(0.0) do |sum, game|
            opponent = all_teams.find { |t| game.opponent.eql? t.team }
            sum + opponent.owp
          end
          @oowp_conference = sum_oowp / games_conference.count.to_f
        end
      end

      def calculate_nonconference_owp(games_by_team)
        if games_nonconference.count > 0
          sum_owp = games_nonconference.inject(0.0) do |sum, game|
            sked = opponent_schedule game.opponent, games_by_team
            ow = sked.inject(0) { |wins, og| wins + og.wins }
            sum + (sked.empty? ? 0.0 : (ow.to_f / sked.count.to_f))
          end
          @owp_nonconference = sum_owp / games_nonconference.count.to_f
        end
      end

      def calculate_nonconference_oowp(all_teams)
        if games_nonconference.count > 0
          sum_oowp = games_nonconference.inject(0.0) do |sum, game|
            opponent = all_teams.find { |t| game.opponent.eql? t.team }
            sum + opponent.owp
          end
          @oowp_nonconference = sum_oowp / games_nonconference.count.to_f
        end
      end

      private

      def initialize_games(games)
        @games = games
        @games_conference = games.select { |game| game.conference? }
        @games_nonconference = games.reject { |game| game.conference? }
      end

      def initialize_rpi
        @owp = 0.0
        @oowp = 0.0
        @owp_conference = 0.0
        @oowp_conference = 0.0
        @owp_nonconference = 0.0
        @oowp_nonconference = 0.0
        @rpi = nil
        @rpi_conference = nil
        @rpi_nonconference = nil
      end

      def calculate_rpi
        0.25 * rpi_win_percentage + 0.5 * owp + 0.25 * oowp
      end

      # these are common, how can we consolidate?
      def calculate_rpi_conference
        0.25 * rpi_win_percentage_conference + 0.5 * owp_conference + 0.25 * oowp_conference
      end

      def calculate_rpi_nonconference
        0.25 * rpi_win_percentage_nonconference + 0.5 * owp_nonconference + 0.25 * oowp_nonconference
      end

      # filters out games against this team
      def opponent_schedule(opponent, games_by_team)
       all = games_by_team[opponent] || []
       all.reject { |game| game.opponent.eql? team }
      end

      # w/l is commonly used, so can we extract it to a module?
      def calculate_record
        initialize_wl
        initialize_wl_conference
        initialize_wl_nonconference
        games.each do |game|
          calculate_wl game
          calculate_wl_conference game
          calculate_wl_nonconference game
        end
      end

      def initialize_wl
        @wins = @rpi_wins = 0
        @losses = @rpi_losses = 0
      end

      def initialize_wl_conference
        @wins_conference = @rpi_wins_conference = 0
        @losses_conference = @rpi_losses_conference = 0
      end

      def initialize_wl_nonconference
        @wins_nonconference = @rpi_wins_nonconference = 0
        @losses_nonconference = @rpi_losses_nonconference = 0
      end

      def calculate_wl(game)
          @wins       += 1 if game.win?
          @losses     += 1 if game.loss?
          @rpi_wins   += game.rpi_wins
          @rpi_losses += game.rpi_losses
      end

      def calculate_wl_conference(game)
        if game.conference?
          @wins_conference       += 1 if game.win?
          @losses_conference     += 1 if game.loss?
          @rpi_wins_conference   += game.rpi_wins
          @rpi_losses_conference += game.rpi_losses
        end
      end

      def calculate_wl_nonconference(game)
        unless game.conference?
          @wins_nonconference       += 1 if game.win?
          @losses_nonconference     += 1 if game.loss?
          @rpi_wins_nonconference   += game.rpi_wins
          @rpi_losses_nonconference += game.rpi_losses
        end
      end
    end
  end
end
