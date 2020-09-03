class ImageFile < ActiveRecord::Base
  
  mount_uploader :file, ImageFileUploader
  
  belongs_to :user
#  belongs_to :event_code
  
#  after_commit :sidekiq_blob_and_image_creation, :on => :create # To circumvent "Can't find ModelName with ID=12345" Sidekiq error, use after_commit
  after_commit :api_blob_and_image_creation, :on => :create
  
#  validates :ticket_number, presence: true
  validates :file, presence: true
#  validates :event_code, presence: true
  
  attr_accessor :process # Virtual attribute to determine if ready to process versions
  attr_accessor :leads_online # Virtual attribute to determine if saving leads online information
  attr_accessor :signature
  
  #############################
  #     Instance Methods      #
  ############################
  
  def default_name
    self.name ||= File.basename(file_url, '.*').titleize
  end
  
  # Create the image record and the blob in the background
  def sidekiq_blob_and_image_creation
    ImageBlobWorker.perform_async(self.id) 
  end
  
  def api_blob_and_image_creation
    self.update_attribute(:process, true)
    event_code_name = self.event_code
    unless self.camera_class.blank? and self.camera_position.blank?
      leads_online_string = self.camera_class + self.camera_position
      leads_online_store_id = self.user.company.leads_online_store_id
    else
      leads_online_string = ""
      leads_online_store_id = ""
    end
    large_image_blob_data = MiniMagick::Image.open(Rails.root.to_s + "/public" + self.file_url).to_blob
    image = Image.create(ticket_nbr: self.ticket_number,
      event_code: event_code_name,
      leadsonline: leads_online_string,
      lol_store_id: leads_online_store_id,
      file_name: self.file_url,
      branch_code: self.branch_code,
      yardid: self.yard_id,
      container_nbr: self.container_number,
      booking_nbr: self.booking_number,
      contr_nbr: self.contract_number,
      camera_name: self.user.full_name.parameterize.underscore,
      camera_group: "JPEGger Web",
      cust_nbr: self.customer_number,
      cust_name: self.customer_name,
      tare_seq_nbr: self.tare_seq_nbr,
      cmdy_nbr: self.tare_seq_nbr,
      cmdy_name: self.commodity_name,
      weight: self.weight,
      vin: self.vin_number,
      tagnbr: self.tag_number,
      service_req_nbr: self.service_request_number,
      file: Base64.encode64(large_image_blob_data))
            
    
#    pn = Pathname.new(self.file_url) # Get the path to the file
#    self.remove_file! # Remove the file and its versions
#    FileUtils.remove_dir "#{Rails.root}/public#{pn.dirname}" # Remove the now empty directory
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
      Rails.logger.info "image_file.latitude_and_longitude: #{e}"
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
      Rails.logger.info "image_file.latitude: #{e}"
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
      Rails.logger.info "image_file.longitude: #{e}"
      return ""
    end
  end
  
  #############################
  #     Class Methods         #
  #############################
  
  def self.delete_files
    require 'pathname'
    require 'fileutils'
    
    ImageFile.where('created_at < ? and created_at > ?', 7.days.ago, 14.days.ago).each do |image_file|
      if image_file.file.file and image_file.file.file.exists?
        pn = Pathname.new(image_file.file_url) # Get the path to the file
        image_file.remove_file! # Remove the file and its versions
        FileUtils.remove_dir "#{Rails.root}/public#{pn.dirname}" # Remove the now empty directory
      end
    end
  end
  
end
