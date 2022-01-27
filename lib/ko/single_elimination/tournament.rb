# frozen_string_literal: true

require 'ko/single_elimination/round'
require 'ko/single_elimination/rounds_map'
require 'ko/single_elimination/match'
require 'ko/single_elimination/matches_queue'

module Ko
  module SingleElimination
    class Tournament
      RIGHT_SIDE_IDENTIFIER = Round::RIGHT_SIDE_IDENTIFIER

      FINALS = {
        2 => { right: "2.#{RIGHT_SIDE_IDENTIFIER}2.1" }.freeze,
        4 => { right: "4.#{RIGHT_SIDE_IDENTIFIER}3.1" }.freeze,
        8 => { right: "8.#{RIGHT_SIDE_IDENTIFIER}4.1" }.freeze,
        16 => { right: "16.#{RIGHT_SIDE_IDENTIFIER}5.1" }.freeze,
        32 => { right: "32.#{RIGHT_SIDE_IDENTIFIER}6.1" }.freeze,
        64 => { right: "64.#{RIGHT_SIDE_IDENTIFIER}7.1" }.freeze,
        128 => { right: "128.#{RIGHT_SIDE_IDENTIFIER}8.1" }.freeze,
        256 => { right: "256.#{RIGHT_SIDE_IDENTIFIER}9.1" }.freeze,
        512 => { right: "512.#{RIGHT_SIDE_IDENTIFIER}10.1" }.freeze,
        1024 => { right: "1024.#{RIGHT_SIDE_IDENTIFIER}11.1" }.freeze,
        2048 => { right: "2048.#{RIGHT_SIDE_IDENTIFIER}12.1" }.freeze
      }.freeze

      attr_reader :size, :rounds
      attr_accessor :final, :left_final

      def initialize(size:)
        @size = size
        @rounds = RoundsMap.new
        @final = nil
      end

      def matches_queue
        @matches_queue ||= MatchesQueue.new(self)
      end

      def as_json
        {
          size: size,
          finals: FINALS[size],
          matches_graph: matches_graph,
          matches_queue: {
            by_position: matches_queue_keys(:by_position),
            by_key: matches_queue_keys(:by_key)
          },
          rounds: rounds.sorted_keys
        }
      end

      private

      def matches_graph
        rounds.values.flat_map do |round|
          round.matches.values.map do |match|
            [
              match.to_s,
              { next: match.next&.to_s }
            ]
          end
        end.to_h
      end

      def matches_queue_keys(by)
        case by
        when :by_position
          matches_queue.by_position.transform_values do |match_in_queue|
            match_in_queue.match.to_s
          end
        when :by_key
          matches_queue.by_key.transform_values(&:position)
        end
      end
    end
  end
end
