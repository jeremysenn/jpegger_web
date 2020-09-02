class Camera < ActiveResource::Base
  self.site = "http://localhost:3000/api/v1"
  
#  belongs_to :camera_type
  
  schema do
    string :camera_name
    string :device_name
    integer :videum_cam_nbr
    integer :flip_flags
    integer :use_global
    string :image_size
    integer :jpeg_quality
    integer :slow_scan
    integer :camera_type
    string :ip_address
    integer :port_nbr
    string :username
    integer :lol_store_id
    string :pwd
    integer :update_flag
    string :leadsonline
    integer :thumbnail
    string :yardid
    integer :disallow_live_feed
    float :UTCOffset
  end
end