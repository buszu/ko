# frozen_string_literal: true

module Ko
  class MatchInQueue
    attr_reader :match, :position

    def initialize(match, position)
      @match = match
      @position = position
    end
  end
end
