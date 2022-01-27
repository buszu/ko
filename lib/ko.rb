# frozen_string_literal: true

require 'ko/version'
require 'ko/double_elimination/tournament_factory'
require 'ko/single_elimination/tournament_factory'

module Ko
  class Error < StandardError; end
  # Your code goes here...

  class << self
    def single_elimination(...)
      SingleElimination::TournamentFactory.tournament(...)
    end

    def double_elimination(...)
      DoubleElimination::TournamentFactory.tournament(...)
    end
  end
end
