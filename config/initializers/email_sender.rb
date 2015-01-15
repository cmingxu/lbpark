module Kernel
  def send_email
    if Settings.send_email_enabled
      yield if block_given?
    end
  end
end
