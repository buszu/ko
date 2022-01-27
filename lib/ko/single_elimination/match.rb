# frozen_string_literal: true

module Ko
  module SingleElimination
    class Match
      attr_reader :round, :number

      def initialize(round:, number:)
        @round = round
        @number = number
      end

      def next(won: true)
        next_won if won
      end

      def to_s
        tournament = round.tournament
        "#{tournament.size}.#{round.key}.#{number}"
      end

      private

      def next_won
        return if round.final?

        round.next.matches[next_number]
      end

      def next_number
        number.even? ? number / 2 : number / 2 + 1
      end
    end
  end
end
