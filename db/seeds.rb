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
  :wechat_subscribe_message => "欢迎您关注萝卜停车微信号, http://demo.6luobo.com",
  :wechat_unsubscribe_message => "byebye",
  :fallback_message => "欢迎您关注萝卜停车微信号, http://demo.6luobo.com"
}

LbSetting.delete_all
lb_settings.each do |k, v|
  LbSetting.send("#{k}=", v)
end
