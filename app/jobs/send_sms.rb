# -*- encoding : utf-8 -*-
class SendSms
  @queue = :send_sms

  def self.perform(id)
    SMS_LOGGER.debug "entering send_sms #{id}"
    return unless sn = SmsCode.find_by_id(id)
    result, error_message = ::SmsSender.send_sms_to_mobile(sn.phone, sn.send_reason, sn.params)
    if result
      sn.sent!
      SMS_LOGGER.debug "send to #{sn.phone} with #{sn.params}"
    else
      SMS_LOGGER.error error_message
    end
  end
end

