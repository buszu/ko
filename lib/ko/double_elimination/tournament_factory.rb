# frozen_string_literal: true

require 'ko/double_elimination/tournament'

module Ko
  module DoubleElimination
    class TournamentFactory
      def self.tournament(...)
        new.build(...)
      end

      def build(...)
        tournament = Tournament.new(...)

        generate_initial_round(tournament)
        generate_loosers_rounds(tournament)
        generate_winners_rounds(tournament)

        tournament
      end

      private

      def generate_initial_round(tournament)
        initial_round = Round.new(type: Round::RIGHT_SIDE_IDENTIFIER, number: 1, tournament: tournament)
        generate_round_matches(initial_round)
        tournament.rounds[initial_round.key] = initial_round
      end

      # rubocop:todo Metrics/MethodLength
      def generate_loosers_rounds(tournament)
        rounds = []
        round_matches_count = tournament.size / 2
        round_number = 1

        while round_matches_count >= 1
          2.times do
            round = Round.new(type: Round::LEFT_SIDE_IDENTIFIER, number: round_number, tournament: tournament)
            generate_round_matches(round)
            tournament.rounds[round.key] = round
            rounds << round
            round_number += 1
          end

          round_matches_count /= 2
        end

        tournament.left_final = rounds.last
        rounds
      end
      # rubocop:enable Metrics/MethodLength

      # rubocop:todo Metrics/AbcSize
      # rubocop:todo Metrics/MethodLength
      def generate_winners_rounds(tournament)
        rounds = []
        i = tournament.size
        round_matches_count = i / 2
        round_number = 2

        while i > 1
          round = Round.new(type: Round::RIGHT_SIDE_IDENTIFIER, number: round_number, tournament: tournament)

          if round_matches_count >= 1
            generate_round_matches(round)
            round_matches_count /= 2
          end

          tournament.rounds[round.key] = round
          rounds << round

          round_number += 1
          i /= 2
        end

        final = Round.new(type: Round::RIGHT_SIDE_IDENTIFIER, number: round_number, tournament: tournament)
        tournament.final = final
        generate_round_matches(final)
        tournament.rounds[final.key] = final
        rounds << final
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength

      def generate_round_matches(round)
        round.matches_count.times do |t|
          number = t.succ
          match = Match.new(round: round, number: number)
          round.matches[number] = match
        end
      end
    end
  end
end
