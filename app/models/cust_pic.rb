class CustPic < ActiveResource::Base
  self.site = "http://localhost:3000/api/v1" # Azure container group API
#  self.site = "http://api:3000/api/v1" # Docker container group API
  
#  validates_presence_of :ticket_nbr
#  validates_presence_of :file
  
#  schema do
#    string :ticket_nbr
#    string :event_code
#    string :yardid
#    string :cust_name
#    string :leadsonline
#    text :file
#  end
  
end