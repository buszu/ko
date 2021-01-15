# frozen_string_literal: true

module Ko
  class Round
    RIGHT_SIDE_IDENTIFIER = 'w'
    LEFT_SIDE_IDENTIFIER = 'l'
    INITIAL_ROUND_NAME = "#{RIGHT_SIDE_IDENTIFIER}1"
    SPECIAL_TYPES = {
      loosers_winner: 'lw',
      winner: 'ww'
    }.freeze

    attr_reader :tournament, :type, :number, :matches

    def initialize(number:, tournament:, type: RIGHT_SIDE_IDENTIFIER)
      @type = type
      @number = number
      @tournament = tournament
      @matches = {}
    end

    def winners?
      type[0] == RIGHT_SIDE_IDENTIFIER
    end

    def loosers?
      type[0] == LEFT_SIDE_IDENTIFIER
    end

    def loosers_odd?
      loosers? && number.odd?
    end

    def initial?
      name == INITIAL_ROUND_NAME
    end

    # def loosers_final?
    #   type == SPECIAL_TYPES[:loosers_final]
    # end

    def name
      "#{type}#{number}"
    end

    def next(won: true)
      won ? next_won : next_lost
    end

    def matches_count
      modified_number = winners? ? number : (number.to_f / 2).ceil
      tournament.size / 2**(modified_number - 1)
    end

    private

    def next_won
      tournament.rounds["#{type}#{number.next}"]
    end

    def next_lost
      return unless winners?

      tournament.rounds["#{type}#{next_lost_number}"]
    end

    def next_lost_number
      return number if number == 1

      2 * (number - 1)
    end
  end
end
