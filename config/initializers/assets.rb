# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( map.js hot_place.js mobile.css staff.js staff.css vendor.js vendor_wechat_config.js vendor/coupons.js
mobile_coupon.js mobile_coupon_tpl_show.js  mobile_coupon_show.js bind_mobile.js mobile_mine.js custom_mobiscroll.js custom_mobiscroll.css
client.js client.css mobile_coupon_pay.js for_public.js park_map_render.js park_map_render.css park_map_mesh.js park_map_mesh.css wechat_park_space_chooser.js underscore/underscore.js)
Rails.application.config.assets.precompile += %w(base/epiceditor.css)
