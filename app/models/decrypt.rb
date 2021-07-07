class Decrypt
  
  #############################
  #     Class Methods      #
  #############################
  
  def self.base64_decode_decrypt(data)
    decipher = OpenSSL::Cipher::AES.new(256, :CBC)
    decipher.decrypt
    decipher.key = [ENV['AES_ENCRYPTION_KEY']].pack("H*")
    decipher.iv = [ENV['AES_ENCRYPTION_IV']].pack("H*")
    decoded = Base64.urlsafe_decode64(data)
    plain = decipher.update(decoded) + decipher.final
    return plain
    rescue Exception => error
      Rails.logger.error error
      return ''
  end
  
end
