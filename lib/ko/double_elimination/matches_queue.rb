# frozen_string_literal: true

require 'ko/match_in_queue'

module Ko
  module DoubleElimination
    class MatchesQueue
      extend Forwardable

      attr_reader :by_position, :by_key
      alias queue by_key

      def_delegators :queue, :[], :each, :map, :keys, :values
      alias get []

      # rubocop:todo Metrics/MethodLength
      def initialize(tournament)
        rounds = tournament.rounds
        sorted_round_keys = rounds.sorted_keys(:running)
        position = 0

        @by_position = {}
        @by_key =
          sorted_round_keys.flat_map do |key|
            rounds[key].matches.values.sort_by(&:number).map do |match|
              position += 1

              match_in_queue = MatchInQueue.new(match, position)
              array_by_key = [match.to_s, match_in_queue]
              @by_position[position] = match_in_queue

              array_by_key
            end
          end.to_h
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
