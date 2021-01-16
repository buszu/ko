# frozen_string_literal: true

module Ko
  class TournamentTreeCell
    def initialize(match:, position:)
      @match = match
      @position = position
    end

    def to_s
      "#{match.to_s}.#{position}"
    end
  end
end
