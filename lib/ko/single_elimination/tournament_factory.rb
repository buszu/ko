# frozen_string_literal: true

require 'ko/single_elimination/tournament'

module Ko
  module SingleElimination
    class TournamentFactory
      def self.tournament(...)
        new.build(...)
      end

      def build(...)
        tournament = Tournament.new(...)

        generate_initial_round(tournament)
        generate_rounds(tournament)

        tournament
      end

      private

      def generate_initial_round(tournament)
        initial_round = Round.new(number: 1, tournament:)
        generate_round_matches(initial_round)
        tournament.rounds[initial_round.key] = initial_round
      end

      # rubocop:todo Metrics/MethodLength
      def generate_rounds(tournament)
        rounds = []
        i = tournament.size
        round_matches_count = i / 2
        round_number = 2

        while i > 1
          round = Round.new(number: round_number, tournament:)

          if round_matches_count >= 1
            generate_round_matches(round)
            round_matches_count /= 2
          end

          tournament.rounds[round.key] = round
          rounds << round

          round_number += 1
          i /= 2
        end

        final = rounds.last
        tournament.final = final

        rounds
      end
      # rubocop:enable Metrics/MethodLength

      def generate_round_matches(round)
        round.matches_count.times do |t|
          number = t.succ
          match = Match.new(round:, number:)
          round.matches[number] = match
        end
      end
    end
  end
end
