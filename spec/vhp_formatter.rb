class VHPFormatter
  RSpec::Core::Formatters.register self, :example_failed

  def initialize output
    @output = output
  end

  def example_failed(notif)
		@output << notif.description << "\n"
	end
end