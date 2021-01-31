# frozen_string_literal: true

module Ko
  module DoubleElimination
    module Fixed
      class Tournament
        extend Forwardable

        attr_reader :body

        def_delegators :body, :[]
        alias get []

        def initialize(tournament)
          @body = tournament.as_json
        end

        def size
          get(:size)
        end

        def finals
          get(:finals)
        end

        def matches_graph
          get(:matches_graph)
        end

        def matches_queue(by = nil)
          queue = get(:matches_queue)
          return queue if by.nil?

          queue[by]
        end

        def rounds(purpose = nil)
          rounds = get(:rounds)
          return rounds if purpose.nil?

          rounds[purpose]
        end
      end
    end
  end
end
