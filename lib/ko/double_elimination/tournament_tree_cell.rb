# frozen_string_literal: true

module Ko
  module DoubleElimination
    class TournamentTreeCell
      def initialize(match:, position:)
        @match = match
        @position = position
      end

      def to_s
        "#{match}.#{position}"
      end
    end
  end
end
