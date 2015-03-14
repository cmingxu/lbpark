# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( map.js hot_place.js mobile.css staff.js staff.css vendor.js vendor_wechat_config.js vendor/coupons.js mobile_coupon.js mobile_coupon_tpl_show.js)
