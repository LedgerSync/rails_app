class DevError < StandardError
  attr_accessor :message, :data

  def initialize(message, **data)
    self.message = message
    self.data = data

    ErrorNotifier.notify(self, **data)

    super("#{message}: #{data.inspect}")
  end
end
