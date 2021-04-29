class CameraType < ActiveResource::Base
#  self.site = "http://localhost:3000/api/v1" # Azure container group API
  self.site = "http://api:3000/api/v1" # Docker container group API

  def cameras
    Camera.where(camera_type: self.ID)
  end
  
end