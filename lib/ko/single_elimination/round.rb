# frozen_string_literal: true

module Ko
  module SingleElimination
    class Round
      RIGHT_SIDE_IDENTIFIER = 'w'
      INITIAL_ROUND_KEY = "#{RIGHT_SIDE_IDENTIFIER}1"

      attr_reader :tournament, :type, :number, :matches

      def initialize(number:, tournament:)
        @type = RIGHT_SIDE_IDENTIFIER
        @number = number
        @tournament = tournament
        @matches = {}
      end

      def key
        "#{type}#{number}"
      end

      def next(won: true)
        next_won if won
      end

      def matches_count
        return 1 if final?

        tournament.size / 2**(number - 1)
      end

      def initial?
        key == INITIAL_ROUND_KEY
      end

      def final?
        self == tournament.final
      end

      private

      def next_won
        return if final?

        tournament.rounds["#{type}#{number.next}"]
      end
    end
  end
end
