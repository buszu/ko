# frozen_string_literal: true

require 'forwardable'

module Ko
  module DoubleElimination
    class RoundsMap
      extend Forwardable

      attr_reader :content

      def_delegators :content, :[], :[]=, :map, :keys, :values
      alias set []=
      alias get []

      def initialize
        @content = {}
      end

      def sorted_keys(order = :display)
        case order
        when :display
          sorted_keys_for_display
        when :running
          sorted_keys_for_running
        else
          raise Ko::Error, 'order argument must be one of [:display, :running]'
        end
      end

      private

      def sorted_keys_for_display
        return @sorted_keys_for_display if @sorted_keys_for_display

        comparator = method(:display_sort_comparator)
        @sorted_keys_for_display = keys.sort_by(&comparator)
      end

      def display_sort_comparator(key)
        round = get(key)
        priority, factor = round.loosers? ? [1, -1] : [2, 1]
        [priority, factor * round.number]
      end

      # rubocop:todo Metrics/AbcSize
      # rubocop:todo Metrics/MethodLength
      def sorted_keys_for_running
        return @sorted_keys_for_running if @sorted_keys_for_running

        rounds_by_type = values.each_with_object(
          {
            Round::LEFT_SIDE_IDENTIFIER => [],
            Round::RIGHT_SIDE_IDENTIFIER => []
          }
        ) do |round, h|
          h[round.type] << round
        end

        left_rounds = rounds_by_type[Round::LEFT_SIDE_IDENTIFIER]
        right_rounds = rounds_by_type[Round::RIGHT_SIDE_IDENTIFIER]

        left_rounds.sort_by!(&:number)
        right_rounds.sort_by!(&:number)

        sorted_keys = [right_rounds.shift.key]
        while left_rounds.first || right_rounds.first
          sorted_keys << right_rounds.shift.key
          2.times do
            sorted_keys << left_rounds.shift.key if left_rounds.first
          end
        end

        @sorted_keys_for_running = sorted_keys
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength
    end
  end
end
