# frozen_string_literal: true

require_relative "../../../lib/tabry/shells/bash"

describe Tabry::Shells::Bash do
  describe ".generate_self" do
    before { @backup, $0 = $0, "/bla/waz/abc" }
    after { $0 = @backup }

    it "tells bash to use the currently running command plus 'completion' to get completion options" do
      expect(described_class.generate_self).to match(
        %r{^ *TABRY_IMPORTS_PATH='' _tabry_ABC_completions_internal /bla/waz/abc completion$}
      )
    end

    it "uses the cmd_name given for the command name for bash's 'complete'" do
      result = described_class.generate_self
      expect(result).to include("\ncomplete -F _tabry_ABC_completions abc\n")
    end

    it "defaults cmd_name to the basename of the currently running command" do
      result = described_class.generate_self(cmd_name: 'wombat')
      expect(result).to match(
        %r{^ *TABRY_IMPORTS_PATH='' _tabry_WOMBAT_completions_internal /bla/waz/abc completion$}
      )
      expect(result).to include("\ncomplete -F _tabry_WOMBAT_completions wombat\n")
    end
  end

  describe '.generate' do
    it 'tells bash to use tabry-bash with a import path to get completion options' do
      result = described_class.generate("my-cmd", "/path/to/mycmd.tabry")
      expect(result).to include("TABRY_IMPORTS_PATH=/path/to/mycmd.tabry _tabry_MY_CMD_completions_internal /home/evan/dev/tabry/bin/tabry-bash \n")
      expect(result).to include("complete -F _tabry_MY_CMD_completions my-cmd\n")
    end

    it "takes a uniq_fn_id parameter to override the default function names" do
      result = described_class.generate("my-cmd", "/path/to/mycmd.tabry", uniq_fn_id: "my cmd tabryv0.2.0")
      expect(result).to include("TABRY_IMPORTS_PATH=/path/to/mycmd.tabry _tabry_MY_CMD_TABRYV0_2_0_completions_internal /home/evan/dev/tabry/bin/tabry-bash \n")
      expect(result).to include("complete -F _tabry_MY_CMD_TABRYV0_2_0_completions my-cmd\n")
      expect(result).to include("_tabry_MY_CMD_TABRYV0_2_0_completions_internal()")
    end
  end
end
