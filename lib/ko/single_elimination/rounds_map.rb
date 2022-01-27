# frozen_string_literal: true

require 'forwardable'

module Ko
  module SingleElimination
    class RoundsMap
      extend Forwardable

      attr_reader :content

      def_delegators :content, :[], :[]=, :map, :keys, :values
      alias set []=
      alias get []

      def initialize
        @content = {}
      end

      def sorted_keys
        return @sorted_keys if @sorted_keys

        @sorted_keys = values.sort_by!(&:number).map(&:key)
      end
    end
  end
end
