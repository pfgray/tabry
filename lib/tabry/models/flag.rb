require_relative 'config_object'
require_relative 'options_list'

module Tabry
  module Models
    class Flag < ConfigObject
      FIELDS = {
        aliases: :string_array,
        description: :string,
        name: :string, # TODO required
        required: :boolean,
        arg: :boolean,
        options: [:list_object, :OptionsList]
      }

      def match_with_value(token)
        [name, *aliases].each do |al|
          if al.length > 1 && token.start_with?("--#{al}=")
            return token.sub("--#{al}=", "")
          end
        end
      end

      def match(token)
        [name, *aliases].any?{|al| token == alias_with_dash(al)}
      end

      def name_with_dashes
        @name_with_dashes ||= alias_with_dash(name)
      end

      def alias_with_dash(al)
        al.length == 1 ? "-#{al}" : "--#{al}"
      end
    end
  end
end

