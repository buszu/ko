# frozen_string_literal: true

module Ko
  class Match
    attr_reader :round, :number

    def initialize(round:, number:)
      @round = round
      @number = number
    end

    def next(won: true)
      won ? next_won : next_lost
    end

    def to_s
      tournament = round.tournament
      "#{tournament.size}.#{round.name}.#{number}"
    end

    private

    def next_won
      round.next.matches[next_number]
    end

    def next_lost
      next_number =
        if round.initial?
          next_number
        else
          round.matches_count - number + 1
        end

      round.next(won: false).matches[next_number]
    end

    def next_number
      return number if round.loosers_odd?

      number.even? ? number / 2 : number / 2 + 1
    end
  end
end