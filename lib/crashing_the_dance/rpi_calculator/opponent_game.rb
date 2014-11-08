module CrashingTheDance
  module RpiCalculator
    class OpponentGame
      attr_reader :game, :team, :opponent, :score, :opponent_score
      def initialize(game, team)
        @game = game
        @team = team
        scores
      end

      def neutral?
        game.neutral?
      end

      def win?
        score > opponent_score
      end

      def loss?
        score < opponent_score
      end

      def wins
        win? ? 1 : 0
      end

      def losses
        loss? ? 1 : 0
      end

      def rpi_wins
        case
        when loss? then    0.0
        when home? then    0.6
        when visitor? then 1.4
        else               1.0
        end
      end

      def rpi_losses
        case
        when win? then     0.0
        when visitor? then 0.6
        when home? then    1.4
        else               1.0
        end
      end

      def home?
        @which_team == :home && !neutral?
      end

      def visitor?
        @which_team == :visitor && !neutral?
      end

      private

      def scores
        case
        when team.eql?(game.vis_team)
          @opponent = game.home_team
          @which_team = :visitor
          assign_scores(game.vis_score, game.home_score)
        when team.eql?(game.home_team)
          @opponent = game.vis_team
          assign_scores(game.home_score, game.vis_score)
          @which_team = :home
        else
          fail "Couldn't find #{team} in #{game}"
        end
      end

      def assign_scores(score, opponent_score)
        fail "Both teams can't have the same score" if score == opponent_score
        @score = score
        @opponent_score = opponent_score
      end
    end
  end
end

