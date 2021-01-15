# frozen_string_literal: true

module Ko
  class Round
    RIGHT_SIDE_IDENTIFIER = 'w'
    LEFT_SIDE_IDENTIFIER = 'l'
    INITIAL_ROUND_NAME = "#{RIGHT_SIDE_IDENTIFIER}1"
    SPECIAL_TYPES = {
      loosers_winner: 'lw',
      winner: 'fw'
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

    def left_final?
      self == tournament.left_final
    end

    def final?
      self == tournament.final
    end

    def name
      "#{type}#{number}"
    end

    def next(won: true)
      won ? next_won : next_lost
    end

    # rubocop:disable Metrics/AbcSize
    def matches_count
      return 1 if final?

      if winners?
        tournament.size / 2**(number - 1)
      else
        modified_number = (number.to_f / 2).ceil
        tournament.size / 2**(modified_number - 1) / 2
      end
    end
    # rubocop:enable Metrics/AbcSize

    private

    def next_won
      return tournament.rounds["#{SPECIAL_TYPES[:loosers_winner]}0"] if left_final?
      return tournament.rounds["#{SPECIAL_TYPES[:winner]}0"] if final?

      tournament.rounds["#{type}#{number.next}"]
    end

    def next_lost
      return if loosers?

      tournament.rounds["#{LEFT_SIDE_IDENTIFIER}#{next_lost_number}"]
    end

    def next_lost_number
      return number if number == 1

      2 * (number - 1)
    end
  end
end
