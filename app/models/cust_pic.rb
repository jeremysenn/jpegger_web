class CustPic < ActiveResource::Base
  self.site = "#{ENV['JPEGGER_API_URL']}" # Docker container group API
  
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