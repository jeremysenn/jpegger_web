class CameraType < ActiveResource::Base
  self.site = "#{ENV['JPEGGER_API_URL']}" # Docker container group API

  def cameras
    Camera.where(camera_type: self.ID)
  end
  
end