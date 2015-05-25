# == Schema Information
#
# Table name: plugins
#
#  id            :integer          not null, primary key
#  client_id     :integer
#  plugin_tpl_id :integer
#  begin_at      :datetime
#  end_at        :datetime
#  created_at    :datetime
#  updated_at    :datetime
#  enabled       :boolean
#

require 'test_helper'

class PluginTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
