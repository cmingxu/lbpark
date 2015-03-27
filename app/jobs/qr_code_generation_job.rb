# -*- encoding : utf-8 -*-
class QrCodeGenerationJob
  @queue = :qr_code_generation_job

  def self.perform(id)
    qr_code  = QrCode.find(id)
    qr_code.generate_qr_code
  end
end

