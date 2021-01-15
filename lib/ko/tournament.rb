# frozen_string_literal: true

require 'ko/round'
require 'ko/match'

module Ko
  class Tournament
    DOUBLE_KNOCKOUT = '2ko'

    attr_reader :type, :size, :rounds

    def initialize(size:, type: DOUBLE_KNOCKOUT)
      @type = type
      @size = size
      @rounds = {}
    end
  end
end
