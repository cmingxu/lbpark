class Plugin::Base
  attr_accessor :icon, :displayable_name, :internal_identifier, :client

  def initialize(client)
    @client = client
  end


end
