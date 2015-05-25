class Client::GatesController < Client::BaseController
  def index
    @gates = current_client.gates
  end
end
