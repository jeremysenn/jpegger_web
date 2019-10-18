class ShipmentBlobWorker
  include Sidekiq::Worker
  
  def perform(shipment_file_id)
    shipment_file = ShipmentFile.find(shipment_file_id)
    shipment_file.update_attribute(:process, true)
    shipment_file.file.recreate_versions!
    event_code_name = shipment_file.event_code

    # Create blob
    large_image_blob_data = MiniMagick::Image.open(Rails.root.to_s + "/public" + shipment_file.file_url(:large)).to_blob

    require 'socket'
    host = shipment_file.user.company.jpegger_service_ip
    port = shipment_file.user.company.jpegger_service_port
    command = "<APPEND>
                <TABLE>shipments</TABLE>
                <BLOB>#{Base64.encode64(large_image_blob_data)}</BLOB>
                <TICKET_NBR>#{shipment_file.ticket_number}</TICKET_NBR>
                <EVENT_CODE>#{event_code_name}</EVENT_CODE>
                <FILE_NAME>#{File.basename(shipment_file.file_url)}</FILE_NAME>
                <BRANCH_CODE>#{shipment_file.branch_code}</BRANCH_CODE>
                <YARDID>#{shipment_file.yard_id}</YARDID>
                <CONTAINER_NBR>#{shipment_file.container_number}</CONTAINER_NBR>
                <BOOKING_NBR>#{shipment_file.booking_number}</BOOKING_NBR>
                <CONTR_NBR>#{shipment_file.contract_number}</CONTR_NBR>
                <CAMERA_NAME>#{"user_#{shipment_file.user.full_name.parameterize.underscore}"}</CAMERA_NAME>
                <CAMERA_GROUP>Scrap Yard Dog</CAMERA_GROUP>
                <CUST_NBR>#{shipment_file.customer_number}</CUST_NBR>
                <CUST_NAME>#{shipment_file.customer_name}</CUST_NAME>
              </APPEND>"
    
    tcp_client = TCPSocket.new host, port
    ssl_client = OpenSSL::SSL::SSLSocket.new tcp_client
    ssl_client.connect
    ssl_client.sync_close = true
    ssl_client.puts command
    ssl_client.close
    
  end
end