class Api::WechatController < Api::BaseController
  wechat_responder appid: Wechat.config.appid,
    secret: Wechat.config.secret, token: Wechat.config.token, access_token: Wechat.config.access_token

  on :event, with: "subscribe" do |request, event|
    WechatUser.user_subscribe!(request)
    WechatUserActivity.log_activity!(request, "event", "subscribe")
    LB_WECHAT_LOGGER.info "event subscribe #{request.message_hash}"
    request.reply.text LbSetting.wechat_subscribe_message
  end

  on :event, with: "unsubscribe" do |request, event|
    WechatUser.user_unsubscribe!(request)
    WechatUserActivity.log_activity!(request, "event", "unsubscribe")
    LB_WECHAT_LOGGER.info "event unsubscribe #{request.message_hash}"
    request.reply.text LbSetting.wechat_unsubscribe_message
  end

  on :event, with: "Location" do |request, event|
    WechatUserActivity.log_activity!(request, "event", "location")
    LB_WECHAT_LOGGER.info "event location #{request.message_hash}"
    #request.reply.text "event: location"
  end

  on :event, with: "view" do |request, event|
    WechatUserActivity.log_activity!(request, "event", "view")
    LB_WECHAT_LOGGER.info "event view #{request[:EventKey]} #{request.message_hash}"
    #request.reply.text LbSetting.wechat_subscribe_message
  end

  on :event, with: "click" do |request, event|
    WechatUserActivity.log_activity!(request, "event", "click")
    LB_WECHAT_LOGGER.info "event click #{request[:EventKey]} #{request.message_hash}"
    #request.reply.text LbSetting.wechat_subscribe_message
  end


  # 默认的文字信息responder
  on :text do |request, content|
    #request.reply.text "echo: #{content}" #Just echo
    request.reply.text LbSetting.wechat_subscribe_message
  end

  # 当请求的文字信息内容为'help'时, 使用这个responder处理
  on :text, with:"help" do |request, help|
    #request.reply.text "help content" #回复帮助信息
    request.reply.text LbSetting.wechat_subscribe_message
  end

  # 当请求的文字信息内容为'help'时, 使用这个responder处理
  on :text, with:"abc" do |request, help|
    #request.reply.text "help content" #回复帮助信息
    request.reply.text "<a href='http://m.6luobo.com/mobile/map?name=#{help}'>#{help}</a>"
  end

  # 当请求的文字信息内容为'<n>条新闻'时, 使用这个responder处理, 并将n作为第二个参数
  on :text, with: /^(\d+)条新闻$/ do |request, count|
    articles_range = (0... [count.to_i, 10].min)
    request.reply.news(articles_range) do |article, i| #回复"articles"
      article.item title: "标题#{i}", description:"内容描述#{i}", pic_url: "http://www.baidu.com/img/bdlogo.gif", url:"http://www.baidu.com/"
    end
  end

  on :text, with: /([\p{Han}|\w]+)/u do |request, r|
    parks = Park.where(["name like ? OR code like ? OR pinyin like ?", "%#{r}%",
                "#{r}%", "#{r.scan(/\w/).map{|w| w + "%"}.join('')}" ]).limit(6)

    if parks.present?
      request.reply.text(parks.map do |help|
        "<a href='http://m.6luobo.com/mobile/map?name=#{help.name}'>#{help.name}</a>"
      end.join("\n"))
    else
      request.reply.text "萝卜没能找到您需要的停车场， 试着如“海淀剧院”，“haidianjuyuan”或者“hdjy”。"
    end
  end

  # 处理图片信息
  on :image do |request|
    request.reply.image(request[:MediaId]) #直接将图片返回给用户
  end

  # 处理语音信息
  on :voice do |request|
    request.reply.voice(request[:MediaId]) #直接语音音返回给用户
  end

  # 处理视频信息
  on :video do |request|
    nickname = wechat.user(request[:FromUserName])["nickname"] #调用 api 获得发送者的nickname
    request.reply.video(request[:MediaId], title: "回声", description: "#{nickname}发来的视频请求") #直接视频返回给用户
  end

  # 处理地理位置信息
  on :location do |request|
    request.reply.text("#{request[:Location_X]}, #{request[:Location_Y]}") #回复地理位置
  end

  # 当无任何responder处理用户信息时,使用这个responder处理
  on :fallback, respond: ""# LbSetting.wechat_subscribe_message
end
