# frozen_string_literal: true

require 'ko/double_elimination/round'
require 'ko/double_elimination/rounds_map'
require 'ko/double_elimination/match'

module Ko
  module DoubleElimination
    class Tournament
      attr_reader :size, :rounds
      attr_accessor :final, :left_final

      def initialize(size:)
        @size = size
        @rounds = RoundsMap.new
        @final = nil
        @left_final = nil
      end

      def matches_queue
        sorted_round_keys = rounds.sorted_keys(:running)
        sorted_round_keys.flat_map do |key|
          rounds[key].matches.values.sort_by(&:number)
        end
      end
    end
  end
end
