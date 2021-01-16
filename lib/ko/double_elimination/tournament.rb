# frozen_string_literal: true

require 'ko/double_elimination/round'
require 'ko/double_elimination/match'

module Ko
  module DoubleElimination
    class Tournament
      attr_reader :size, :rounds
      attr_accessor :final, :left_final

      def initialize(size:)
        @size = size
        @rounds = {}
        @final = nil
        @left_final = nil
      end
    end
  end
end
