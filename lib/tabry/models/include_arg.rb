module Tabry
  module Models
    class IncludeArg
      attr_reader :include_name

      def initialize(include_name)
        @include_name = include_name
      end
    end
  end
end
