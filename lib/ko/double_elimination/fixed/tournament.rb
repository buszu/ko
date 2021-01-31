# frozen_string_literal: true

module Ko
  module DoubleElimination
    module Fixed
      class Tournament
        attr_reader :body

        def initialize(tournament)
          @body = tournament.as_json
        end
      end
    end
  end
end
