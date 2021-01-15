# frozen_string_literal: true

module Ko
  class TournamentCellIdentifier
    attr_reader :size, :round, :match, :position

    def initialize(size:, round:, match:, position:)
      @size = size
      @round = round.is_a?(Round) ? round : Round.new(round)
      @match = match
      @position = position
    end

    def to_s
      "S-#{size}-R-#{round}-M-#{match}-P-#{position}"
    end

    def next(won: true)
      won ? next_won : next_lost
    end

    def next_won
      if round.loosers_final?
        self.class.new(size: size, round: round.next_won, match: 2, position: 2)
      else
        self.class.new(size: size, round: round.next_won, match: next_won_match, position: next_won_position)
      end
    end

    private

    def next_won_position
      match.number.even? ? 2 : 1
    end
  end

  TCI = TournamentCellIdentifier
end
