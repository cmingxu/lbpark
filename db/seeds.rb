# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
#

staffs = %w( luobotao luobaogao luobogen luobojing luobokuai luobobai luoboyun )
staffs.each do |s|
  Staff.create! name: s, email: s+"@qq.com", password: s+"@qq.com"
end

lb_settings = {
  :wechat_subscribe_message => "一个萝卜一个坑，现场用“找车位”，异地用“提前搜”，祝您停车愉快~",
  :wechat_unsubscribe_message => "byebye",
  :fallback_message => "欢迎您关注萝卜停车微信号, http://demo.6luobo.com",
  :vendor_wechat_subscribe_message => "谢谢小哥赏脸，工作之余先“报状态”再“看彩票”，祝你好运~",
  :vendor_wechat_unsubscribe_message => "byebye",
  :vendor_fallback_message => "欢迎您关注萝卜停车微信号, http://demo.6luobo.com"
}

LbSetting.delete_all
lb_settings.each do |k, v|
  LbSetting.send("#{k}=", v)
end
