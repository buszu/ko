# frozen_string_literal: true

require 'ko/round'
require 'ko/match'

module Ko
  class Tournament
    DOUBLE_KNOCKOUT = '2ko'

    attr_reader :type, :size, :rounds
    attr_accessor :final, :left_final

    def initialize(size:, type: DOUBLE_KNOCKOUT)
      @type = type
      @size = size
      @rounds = {}
      @final = nil
      @left_final = nil
    end
  end
end
