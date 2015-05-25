class Client::GateEventsController < Client::BaseController
  def index
    @gate = current_client.gates.find params[:gate_id]
    @gate_events = @gate.gate_events.page params[:page]
  end
end
