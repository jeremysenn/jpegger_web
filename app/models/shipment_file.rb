class ShipmentFile < ActiveRecord::Base
  
  mount_uploader :file, ShipmentFileUploader
  
  belongs_to :user
#  belongs_to :event_code
  
  after_commit :sidekiq_blob_and_shipment_creation, :on => :create # To circumvent "Can't find ModelName with ID=12345" Sidekiq error, use after_commit
  
#  validates :ticket_number, presence: true
  validates :file, presence: true
#  validates :event_code, presence: true
  
  attr_accessor :process # Virtual attribute to determine if ready to process versions
  attr_accessor :leads_online # Virtual attribute to determine if saving leads online information
  
  #############################
  #     Instance Methods      #
  ############################
  
  def default_name
    self.name ||= File.basename(file_url, '.*').titleize
  end
  
  # Create the shipment record and the blob in the background
  def sidekiq_blob_and_shipment_creation
    ShipmentBlobWorker.perform_async(self.id) 
  end
  
  def latitude_and_longitude
    begin
      data = Exif::Data.new(File.open(self.file.current_path))

      latitude = data.gps_latitude
      longitude = data.gps_longitude

      latitude_decimal = latitude.blank? ? nil : (latitude[0] + latitude[1]/60 + latitude[2]/3600).to_f
      longitude_decimal = longitude.blank? ? nil : (longitude[0] + longitude[1]/60 + longitude[2]/3600).to_f

      unless latitude_decimal.blank? or longitude_decimal.blank?
        return "#{latitude_decimal}, #{longitude_decimal}"
      else
        return ""
      end
    rescue => e
      Rails.logger.info "shipment_file.latitude_and_longitude: #{e}"
      return ""
    end
  end
  
  def latitude
    begin
      data = Exif::Data.new(File.open(self.file.current_path))

      latitude = data.gps_latitude

      latitude_decimal = latitude.blank? ? nil : (latitude[0] + latitude[1]/60 + latitude[2]/3600).to_f

      unless latitude_decimal.blank?
        return "#{latitude_decimal}"
      else
        return ""
      end
    rescue => e
      Rails.logger.info "shipment_file.latitude: #{e}"
      return ""
    end
  end
  
  def longitude
    begin
      data = Exif::Data.new(File.open(self.file.current_path))

      longitude = data.gps_longitude

      longitude_decimal = longitude.blank? ? nil : (longitude[0] + longitude[1]/60 + longitude[2]/3600).to_f

      unless longitude_decimal.blank?
        return "#{longitude_decimal}"
      else
        return ""
      end
    rescue => e
      Rails.logger.info "shipment_file.longitude: #{e}"
      return ""
    end
  end
  
  #############################
  #     Class Methods         #
  #############################
  
  def self.delete_files
    require 'pathname'
    require 'fileutils'
    
    ShipmentFile.where('created_at < ? and created_at > ?', 7.days.ago, 14.days.ago).each do |shipment_file|
      if shipment_file.file.file and shipment_file.file.file.exists?
        pn = Pathname.new(shipment_file.file_url) # Get the path to the file
        shipment_file.remove_file! # Remove the file and its versions
        FileUtils.remove_dir "#{Rails.root}/public#{pn.dirname}" # Remove the now empty directory
      end
    end
  end
  
end
