require 'httparty'
module SmsSender
  def self.send_sms(opts)
    response =HTTParty.post("http://223.4.21.214:8180/Service.asmx/SendMessage",
                            "Id=300&Name=payaso&Psw=123456&Message=HELLOWORLD&Phone=18611184702&Timestamp=0")


  end
end
