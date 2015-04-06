# == Schema Information
#
# Table name: qr_codes
#
#  id                   :integer          not null, primary key
#  appid                :string(255)
#  which_wechat_account :string(255)
#  status               :string(255)
#  qr_code              :string(255)
#  ticket               :string(255)
#  scene_str            :string(255)
#  mark                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

class QrCode < ActiveRecord::Base
  validates :scene_str, presence: true
  validates :appid, presence: true
  validates :which_wechat_account, presence: true
  validates :scene_str, uniqueness: { :scope => [:appid] }

  before_validation :set_default, :on => :create

  after_commit :generating_qr_code_event
  mount_uploader :qr_code, WechatQrCodeUploader

  state_machine :status, :initial => :created do
    event :generate do
      transition  :from => :created, :to => :generated
    end
  end

  def generating_qr_code_event
    Resque.enqueue_at Time.now, QrCodeGenerationJob, self.id
  end

  def generate_qr_code
    res = api.qr_permnent_create(self.scene_str)
    self.update_column :ticket, res["ticket"]
    sleep 60
    self.qr_code = WechatQrCodeUploader.new
    self.qr_code.download! "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=" + res["ticket"]
    self.save
    self.generate
  end

  def vendor?
    self.which_wechat_account == 'vendor'
  end

  def api
    self.vendor? ? $vendor_wechat_api : $wechat_api
  end

  def set_default
    self.appid = self.which_wechat_account == "user" ?  Wechat.config.appid : Wechat.config.vendor_appid
  end
end
