# frozen_string_literal: true

require 'ko/round'
require 'ko/match'

module Ko
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
