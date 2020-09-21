class CameraType < ActiveResource::Base
#  self.site = "http://localhost:3000/api/v1"
  self.site = "http://api:3000/api/v1"

  def cameras
    Camera.where(camera_type: self.ID)
  end
  
end