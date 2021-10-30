require_relative 'config_object'

module Tabry
  module Models
    class DirectoryOption < ConfigObject
      FIELDS = {
        type: :string,
      }

      attr_reader *FIELDS.keys

      def options(token)
        [:directory]
      end
    end
  end
end
