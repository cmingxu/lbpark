# == Schema Information
#
# Table name: plugin_tpls
#
#  id             :integer          not null, primary key
#  identifier     :string(255)
#  name           :string(255)
#  icon           :string(255)
#  big_icon       :string(255)
#  base_price     :integer
#  desc           :text
#  created_at     :datetime
#  updated_at     :datetime
#  default_to_all :boolean
#  entry_url      :string(255)
#  fa_icon        :string(255)
#

require 'test_helper'

class PluginTplTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
