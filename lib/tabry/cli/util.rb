# frozen_string_literal: true

require "shellwords"

# Utils that may be useful to CLIs
module Tabry
  module CLI
    module Util
      module_function

      def make_cmdline(cmdline, *args, echo: false, echo_only: false)
        # Allow to pass in an array, or varargs:
        args = args.first if args.length == 1 && args.first.is_a?(Array)

        args = args.map do |arg|
          if arg.is_a?(Array)
            # array of arguments get escaped separately and joined with strings (see specs)
            arg.map { |a| Shellwords.escape(a) }.join(" ")
          else
            Shellwords.escape(arg)
          end
        end
        cmdline = cmdline % args

        warn cmdline if echo || echo_only
        return nil if echo_only

        cmdline
      end

      def system(*cmdline, **opts)
        cmdline = make_cmdline(*cmdline, **opts)
        Kernel.system cmdline if cmdline
      end

      # TODO: would be nice to get separate STDERR and STDOUT
      def backtick_or_die(*cmdline, **opts)
        backtick_with_process_status(*cmdline, **opts).first
      end

      def backtick_with_process_status(*cmdline, valid_statuses: [0], **opts)
        cmdline = make_cmdline(*cmdline, **opts)
        return [nil, nil] unless cmdline

        res = `#{cmdline}`
        status = $?
        if valid_statuses && !valid_statuses.include?(status.exitstatus)
          warn "COMMAND FAILED with exit code #{status.exitstatus}: #{cmdline}"
          exit 1
        end
        [res, status]
      end

      def open_web_page(url)
        command = RUBY_PLATFORM.include?("linux") ? "xdg-open" : "open"
        unless system("(%s %s 2>&1) >/dev/null", command, url)
          warn "WARNING: opening web page failed: #{make_cmdline("%s %s", command, url)}"
        end
      end
    end
  end
end
