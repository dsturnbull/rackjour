require 'spec/runner/formatter/specdoc_formatter'

class CustomSpecFormatter < Spec::Runner::Formatter::SpecdocFormatter
  def example_pending(example, message, deprecated_pending_location=nil)
    output.puts yellow("- #{example.description} (PENDING: #{message})")
    output.flush
  end
end

