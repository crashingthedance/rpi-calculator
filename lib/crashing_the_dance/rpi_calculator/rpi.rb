module CrashingTheDance
  module RpiCalculator
    class RPI
      attr_reader :team, :games, :wins, :losses, :rpi_wins, :rpi_losses

      def initialize(team, games)
        @team = team
        @games = games
        @owp = 0.0
        @oowp = 0.0
        @rpi = nil
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

      def owp
        @owp
      end

      def oowp
        @oowp
      end

      def rpi
        @rpi ||= calculate_rpi
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

      private

      def calculate_rpi
        0.25 * rpi_win_percentage + 0.5 * owp + 0.25 * oowp
      end

      # filters out games against this team
      def opponent_schedule(opponent, games_by_team)
       all = games_by_team[opponent] || []
       all.reject { |game| game.opponent.eql? team }
      end

      # w/l is commonly used, so can we extract it to a module?
      def calculate_record
        @wins = @rpi_wins = 0
        @losses = @rpi_losses = 0
        games.each do |game|
          @wins       += 1 if game.win?
          @losses     += 1 if game.loss?
          @rpi_wins   += game.rpi_wins
          @rpi_losses += game.rpi_losses
        end
      end
    end
  end
end
