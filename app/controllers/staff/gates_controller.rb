class Staff::GatesController < Staff::BaseController
  before_filter do
    @active_nav_item = "parks"
    @park = Park.find params[:park_id]
  end

  def index
    @gates = @park.gates
  end

  def edit
    @gate = @park.gates.find params[:id]
  end

  def new
    @gate = @park.gates.build
    @gate.version = Time.now.to_i
    @gate.serial_num = SecureRandom.hex(8)
  end

  def create
    @gate = @park.gates.build gate_params
    @gate.client = @park.client
    if @gate.save
      redirect_to staff_park_gates_path(@park), :notice => "Save Success"
    else
      render :new, :notice => @gate.errors.full_messages.first
    end
  end

  def build
    @gate = @park.gates.find params[:id]
    if @gate.update_attributes gate_params
      redirect_to staff_park_gates_path(@park), :notice => "Save Success"
    else
      render :edit, :notice => @gate.errors.full_messages.first
    end
  end

  def gate_params
    params.require(:gate).permit(:serial_num, :is_in, :hardware_version, :version, :name)
  end
end
