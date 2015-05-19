class Staff::PluginTplsController < Staff::BaseController
  before_filter do
    @active_nav_item = "plugin_tpls"
  end

  def index
    @plugin_tpls = PluginTpl.all
    @client = Client.find_by_id(params[:client_id]) || Client.first
    @plugins = @client.plugins
  end

  def edit
    @plugin_tpl =  PluginTpl.find params[:id]
  end

  def create_plugin
    @client = Client.find_by_id(params[:client_id])

    @client.plugins.build plugin_params
    @client.save
    redirect_to :back
  end

  def update
    @plugin_tpl =  PluginTpl.find params[:id]
    @plugin_tpl.update_attributes plugin_tpl_params
    redirect_to edit_staff_plugin_tpl_path(@plugin_tpl)
  end

  def plugin_tpl_params
    params.require(:plugin_tpl).permit(:identifier, :name, :icon, :big_icon, :base_price, :desc, :default_to_all)
  end

  def plugin_params
    params.require(:plugin).permit(:plugin_tpl_id, :begin_at, :end_at)
  end

  def destroy_plugin
    @plugin = Plugin.find_by_id params[:plugin_id]
    @plugin.enabled = false
    @plugin.save
    redirect_to :back
  end
end
