# frozen_string_literal: true

require 'ko/double_elimination/round'
require 'ko/double_elimination/rounds_map'
require 'ko/double_elimination/match'
require 'ko/double_elimination/matches_queue'

module Ko
  module DoubleElimination
    class Tournament
      LEFT_SIDE_IDENTIFIER = Round::LEFT_SIDE_IDENTIFIER
      RIGHT_SIDE_IDENTIFIER = Round::RIGHT_SIDE_IDENTIFIER

      FINALS = {
        2 => {
          left: "2.#{LEFT_SIDE_IDENTIFIER}2.1",
          right: "2.#{RIGHT_SIDE_IDENTIFIER}3.1"
        }.freeze,
        4 => {
          left: "4.#{LEFT_SIDE_IDENTIFIER}4.1",
          right: "4.#{RIGHT_SIDE_IDENTIFIER}4.1"
        }.freeze,
        8 => {
          left: "8.#{LEFT_SIDE_IDENTIFIER}6.1",
          right: "8.#{RIGHT_SIDE_IDENTIFIER}5.1"
        }.freeze,
        16 => {
          left: "16.#{LEFT_SIDE_IDENTIFIER}8.1",
          right: "16.#{RIGHT_SIDE_IDENTIFIER}6.1"
        }.freeze,
        32 => {
          left: "32.#{LEFT_SIDE_IDENTIFIER}10.1",
          right: "32.#{RIGHT_SIDE_IDENTIFIER}7.1"
        }.freeze,
        64 => {
          left: "64.#{LEFT_SIDE_IDENTIFIER}12.1",
          right: "64.#{RIGHT_SIDE_IDENTIFIER}8.1"
        }.freeze,
        128 => {
          left: "128.#{LEFT_SIDE_IDENTIFIER}14.1",
          right: "128.#{RIGHT_SIDE_IDENTIFIER}9.1"
        }.freeze,
        256 => {
          left: "256.#{LEFT_SIDE_IDENTIFIER}16.1",
          right: "256.#{RIGHT_SIDE_IDENTIFIER}10.1"
        }.freeze,
        512 => {
          left: "512.#{LEFT_SIDE_IDENTIFIER}18.1",
          right: "512.#{RIGHT_SIDE_IDENTIFIER}11.1"
        }.freeze,
        1024 => {
          left: "1024.#{LEFT_SIDE_IDENTIFIER}20.1",
          right: "1024.#{RIGHT_SIDE_IDENTIFIER}12.1"
        }.freeze,
        2048 => {
          left: "2048.#{LEFT_SIDE_IDENTIFIER}22.1",
          right: "2048.#{RIGHT_SIDE_IDENTIFIER}13.1"
        }.freeze
      }.freeze

      attr_reader :size, :rounds
      attr_accessor :final, :left_final

      def initialize(size:)
        raise invalid_size(size) unless FINALS.keys.include?(size)

        @size = size
        @rounds = RoundsMap.new
        @final = nil
        @left_final = nil
      end

      def matches_queue
        @matches_queue ||= MatchesQueue.new(self)
      end

      # rubocop:disable Metrics/MethodLength
      def as_json
        {
          size:,
          finals: FINALS[size],
          matches_graph:,
          matches_queue: {
            by_position: matches_queue_keys(:by_position),
            by_key: matches_queue_keys(:by_key)
          },
          rounds: {
            for_display: rounds.sorted_keys(:display),
            for_running: rounds.sorted_keys(:running)
          }
        }
      end
      # rubocop:enable Metrics/MethodLength

      private

      def matches_graph
        rounds.values.flat_map do |round|
          round.matches.values.map do |match|
            [
              match.to_s,
              { next_won: match.next&.to_s,
                next_lost: match.next(won: false)&.to_s }
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

      def invalid_size(size)
        raise(ArgumentError, "Size #{size} is invalid. Valid sizes: #{FINALS.keys}")
      end
    end
  end
end
