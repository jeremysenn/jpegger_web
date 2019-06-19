class Image
  
  # Open and read jpegger image preview page, over ssl
  def self.preview(capture_sequence_number, company_id)
    company = Company.find(company_id)
    require "open-uri"
    url = "https://#{company.jpegger_service_ip}:#{company.jpegger_service_port}/sdcgi?preview=y&table=images&capture_seq_nbr=#{capture_sequence_number}"
    return open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read
  end
  
  def self.preview_source(capture_sequence_number, company_id)
    company = Company.find(company_id)
    require "open-uri"
    url = "https://#{company.jpegger_service_ip}:#{company.jpegger_service_port}/sdcgi?preview=y&table=images&capture_seq_nbr=#{capture_sequence_number}"
    image =  open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read
    unless image.blank?
      "data:image/jpg;base64, #{Base64.encode64(image)}"
    else
      nil
    end
  end
  
  # Open and read jpegger image jpeg_image page, over ssl
  def self.jpeg_image(capture_sequence_number, company_id)
    company = Company.find(company_id)
    require "open-uri"
    url = "https://#{company.jpegger_service_ip}:#{company.jpegger_service_port}/sdcgi?image=y&table=images&capture_seq_nbr=#{capture_sequence_number}"
    return open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read
  end
  
  def self.jpeg_image_source(capture_sequence_number, company_id)
    company = Company.find(company_id)
    require "open-uri"
    url = "https://#{company.jpegger_service_ip}:#{company.jpegger_service_port}/sdcgi?image=y&table=images&capture_seq_nbr=#{capture_sequence_number}"
    image = open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read
    unless image.blank?
      "data:image/jpg;base64, #{Base64.encode64(image)}"
    else
      nil
    end
  end
  
  def self.find_by_capture_sequence_number(capture_sequence_number, company_id)
    company = Company.find(company_id)
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    # SQL command that gets sent to jpegger service
    command = "<FETCH><SQL>select * from images where capture_seq_nbr='#{capture_sequence_number}'</SQL><ROWS>100</ROWS></FETCH>"
    
    # SSL TCP socket communication with jpegger
    tcp_client = TCPSocket.new host, port
    ssl_client = OpenSSL::SSL::SSLSocket.new tcp_client
    ssl_client.connect
    ssl_client.sync_close = true
    ssl_client.puts command
    response = ssl_client.sysread(200000) # Read up to 200,000 bytes
    ssl_client.close
    
    data= Hash.from_xml(response.gsub(/&/, '/&amp;')) # Convert xml response to a hash, escaping ampersands first
    
    unless data["RESULT"]["ROW"].blank?
      return data["RESULT"]["ROW"] # SQL response comes back in <RESULT><ROW>
    else
      return nil # No image found
    end
  end
  
  # Get all jpegger images for this company with this ticket number
  def self.find_all_by_ticket_number(ticket_number, company_id)
    company = Company.find(company_id)
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    # SQL command that gets sent to jpegger service
    command = "<FETCH><SQL>select * from images where ticket_nbr='#{ticket_number}'</SQL><ROWS>1000</ROWS></FETCH>"
    
    # SSL TCP socket communication with jpegger
    tcp_client = TCPSocket.new host, port
    ssl_client = OpenSSL::SSL::SSLSocket.new tcp_client
    ssl_client.connect
    ssl_client.sync_close = true
    ssl_client.puts command

    results = ""
    while response = ssl_client.sysread(1000) # Read 1000 bytes at a time
      results = results + response
      break if (response.include?("</RESULT>"))
    end
    
    ssl_client.close
    
    data= Hash.from_xml(results.gsub(/&/, '/&amp;')) # Convert xml response to a hash, escaping ampersands first
    
    unless data["RESULT"]["ROW"].blank?
      if data["RESULT"]["ROW"].is_a? Hash # Only one result returned, so put it into an array
        return [data["RESULT"]["ROW"]]
      else
        return data["RESULT"]["ROW"]
      end
    else
      return [] # No images found
    end
  end
  
  def self.find_all_by_date_range(start_date, end_date, user)
    company = Company.find(user.company_id)
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    # SQL command that gets sent to jpegger service
#    command = "<FETCH><SQL>select * from images where SYS_DATE_TIME >= '#{start_date}' AND SYS_DATE_TIME <= '#{end_date}'</SQL><ROWS>1000</ROWS></FETCH>"
    command = "<FETCH><SQL>select * from images where SYS_DATE_TIME BETWEEN '#{start_date}' AND '#{end_date}'</SQL><ROWS>1000</ROWS></FETCH>"
    
    # SSL TCP socket communication with jpegger
    tcp_client = TCPSocket.new host, port
    ssl_client = OpenSSL::SSL::SSLSocket.new tcp_client
    ssl_client.connect
    ssl_client.sync_close = true
    ssl_client.puts command

    results = ""
    while response = ssl_client.sysread(1000) # Read 1000 bytes at a time
      results = results + response
      break if (response.include?("</RESULT>"))
    end
    
    ssl_client.close
    
    data= Hash.from_xml(results.gsub(/&/, '/&amp;')) # Convert xml response to a hash, escaping ampersands first
    
    unless data["RESULT"]["ROW"].blank?
      if data["RESULT"]["ROW"].is_a? Hash # Only one result returned, so put it into an array
        return [data["RESULT"]["ROW"]]
      else
        return data["RESULT"]["ROW"]
      end
    else
      return [] # No images found
    end
  end
  
  def self.external_user_find_all_by_date_range(start_date, end_date, user)
    company = Company.find(user.company_id)
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    # SQL command that gets sent to jpegger service
#    command = "<FETCH><SQL>select * from images where SYS_DATE_TIME >= '#{start_date}' AND SYS_DATE_TIME <= '#{end_date}'</SQL><ROWS>1000</ROWS></FETCH>"
    command = "<FETCH><SQL>select * from images where cust_name='#{user.customer_name}' SYS_DATE_TIME BETWEEN '#{start_date}' AND '#{end_date}'</SQL><ROWS>1000</ROWS></FETCH>"
    
    # SSL TCP socket communication with jpegger
    tcp_client = TCPSocket.new host, port
    ssl_client = OpenSSL::SSL::SSLSocket.new tcp_client
    ssl_client.connect
    ssl_client.sync_close = true
    ssl_client.puts command

    results = ""
    while response = ssl_client.sysread(1000) # Read 1000 bytes at a time
      results = results + response
      break if (response.include?("</RESULT>"))
    end
    
    ssl_client.close
    
    data= Hash.from_xml(results.gsub(/&/, '/&amp;')) # Convert xml response to a hash, escaping ampersands first
    
    unless data["RESULT"]["ROW"].blank?
      if data["RESULT"]["ROW"].is_a? Hash # Only one result returned, so put it into an array
        return [data["RESULT"]["ROW"]]
      else
        return data["RESULT"]["ROW"]
      end
    else
      return [] # No images found
    end
  end
  
  # Get all jpegger images for this company with this customer name
  def self.find_all_by_customer_name(customer_name, company_id)
    company = Company.find(company_id)
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    # SQL command that gets sent to jpegger service
    command = "<FETCH><SQL>select * from images where cust_name LIKE '#{customer_name}'</SQL><ROWS>1000</ROWS></FETCH>"
    
    # SSL TCP socket communication with jpegger
    tcp_client = TCPSocket.new host, port
    ssl_client = OpenSSL::SSL::SSLSocket.new tcp_client
    ssl_client.connect
    ssl_client.sync_close = true
    ssl_client.puts command

    results = ""
    while response = ssl_client.sysread(1000) # Read 1000 bytes at a time
      results = results + response
      break if (response.include?("</RESULT>"))
    end
    
    ssl_client.close
    
    data= Hash.from_xml(results.gsub(/&/, '/&amp;')) # Convert xml response to a hash, escaping ampersands first
    
    unless data["RESULT"]["ROW"].blank?
      if data["RESULT"]["ROW"].is_a? Hash # Only one result returned, so put it into an array
        return [data["RESULT"]["ROW"]]
      else
        return data["RESULT"]["ROW"]
      end
    else
      return [] # No images found
    end
  end
  
  # Get all jpegger images for this company with this event_code
  def self.find_all_by_event_code(event_code, company_id)
    company = Company.find(company_id)
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    # SQL command that gets sent to jpegger service
    command = "<FETCH><SQL>select * from images where event_code LIKE '#{event_code}'</SQL><ROWS>1000</ROWS></FETCH>"
    
    # SSL TCP socket communication with jpegger
    tcp_client = TCPSocket.new host, port
    ssl_client = OpenSSL::SSL::SSLSocket.new tcp_client
    ssl_client.connect
    ssl_client.sync_close = true
    ssl_client.puts command

    results = ""
    while response = ssl_client.sysread(1000) # Read 1000 bytes at a time
      results = results + response
      break if (response.include?("</RESULT>"))
    end
    
    ssl_client.close
    
    data= Hash.from_xml(results.gsub(/&/, '/&amp;')) # Convert xml response to a hash, escaping ampersands first
    
    unless data["RESULT"]["ROW"].blank?
      if data["RESULT"]["ROW"].is_a? Hash # Only one result returned, so put it into an array
        return [data["RESULT"]["ROW"]]
      else
        return data["RESULT"]["ROW"]
      end
    else
      return [] # No images found
    end
  end
  
  # Search jpegger images for this company
  def self.search(search_params, user)
    company = Company.find(user.company_id)
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    ticket_number = search_params[:ticket_number]
    customer_name = search_params[:customer_name]
    event_code = search_params[:event_code]
    start_date = search_params[:start_date]
    end_date = search_params[:end_date]
    
    date_search_string = (start_date.present? and end_date.present?) ? "AND SYS_DATE_TIME BETWEEN '#{start_date}' AND '#{end_date}'" : ''
    
    if ticket_number.present?
      if customer_name.present? and event_code.present?
        command = "<FETCH><SQL>select * from images where ticket_nbr='#{ticket_number}' AND cust_name LIKE '#{customer_name}' AND event_code LIKE '#{event_code}' " + date_search_string + "</SQL><ROWS>1000</ROWS></FETCH>"
      elsif customer_name.present?
        command = "<FETCH><SQL>select * from images where ticket_nbr='#{ticket_number}' AND cust_name LIKE '#{customer_name}' " + date_search_string + "</SQL><ROWS>1000</ROWS></FETCH>"
      elsif event_code.present?
        command = "<FETCH><SQL>select * from images where ticket_nbr='#{ticket_number}' AND event_code LIKE '#{event_code}' " + date_search_string + "</SQL><ROWS>1000</ROWS></FETCH>"
      else
        command = "<FETCH><SQL>select * from images where ticket_nbr='#{ticket_number}' " + date_search_string + "</SQL><ROWS>1000</ROWS></FETCH>"
      end
    elsif customer_name.present?
      if event_code.present?
        command = "<FETCH><SQL>select * from images where cust_name LIKE '#{customer_name}' AND event_code LIKE '#{event_code}' " + date_search_string + "</SQL><ROWS>1000</ROWS></FETCH>"
      else
        command = "<FETCH><SQL>select * from images where cust_name LIKE '#{customer_name}' " + date_search_string + "</SQL><ROWS>1000</ROWS></FETCH>"
      end
    elsif event_code.present?
      command = "<FETCH><SQL>select * from images where event_code LIKE '#{event_code}' " + date_search_string + "</SQL><ROWS>1000</ROWS></FETCH>"
    elsif start_date.present? and end_date.present?
      command = "<FETCH><SQL>select * from images where SYS_DATE_TIME BETWEEN '#{start_date}' AND '#{end_date}'</SQL><ROWS>1000</ROWS></FETCH>"
    end
    
    # SSL TCP socket communication with jpegger
    tcp_client = TCPSocket.new host, port
    ssl_client = OpenSSL::SSL::SSLSocket.new tcp_client
    ssl_client.connect
    ssl_client.sync_close = true
    ssl_client.puts command

    results = ""
    while response = ssl_client.sysread(1000) # Read 1000 bytes at a time
      results = results + response
      break if (response.include?("</RESULT>"))
    end
    
    ssl_client.close
    
    data= Hash.from_xml(results.gsub(/&/, '/&amp;')) # Convert xml response to a hash, escaping ampersands first
    
    unless data["RESULT"]["ROW"].blank?
      if data["RESULT"]["ROW"].is_a? Hash # Only one result returned, so put it into an array
        return [data["RESULT"]["ROW"]]
      else
        return data["RESULT"]["ROW"]
      end
    else
      return [] # No images found
    end
  end
  
  # Search jpegger images for external user
  def self.external_user_search(search_params, user)
    company = Company.find(user.company_id)
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    ticket_number = search_params[:ticket_number]
    event_code = search_params[:event_code]
    start_date = search_params[:start_date]
    end_date = search_params[:end_date]
    
    date_search_string = (start_date.present? and end_date.present?) ? "AND SYS_DATE_TIME BETWEEN '#{start_date}' AND '#{end_date}'" : ''
    
    if ticket_number.present?
      if event_code.present?
        command = "<FETCH><SQL>select * from images where cust_name='#{user.customer_name}' AND ticket_nbr='#{ticket_number}' AND event_code LIKE '#{event_code}' " + date_search_string + "</SQL><ROWS>1000</ROWS></FETCH>"
      else
        command = "<FETCH><SQL>select * from images where cust_name='#{user.customer_name}' AND ticket_nbr='#{ticket_number}' " + date_search_string + "</SQL><ROWS>1000</ROWS></FETCH>"
      end
    elsif event_code.present?
      command = "<FETCH><SQL>select * from images where cust_name='#{user.customer_name}' AND event_code LIKE '#{event_code}' " + date_search_string + "</SQL><ROWS>1000</ROWS></FETCH>"
    elsif start_date.present? and end_date.present?
      command = "<FETCH><SQL>select * from images where cust_name='#{user.customer_name}' AND SYS_DATE_TIME BETWEEN '#{start_date}' AND '#{end_date}'</SQL><ROWS>1000</ROWS></FETCH>"
    else
      command = "<FETCH><SQL>select * from images where cust_name='#{user.customer_name}'</SQL><ROWS>1000</ROWS></FETCH>"
    end
    
    # SSL TCP socket communication with jpegger
    tcp_client = TCPSocket.new host, port
    ssl_client = OpenSSL::SSL::SSLSocket.new tcp_client
    ssl_client.connect
    ssl_client.sync_close = true
    ssl_client.puts command

    results = ""
    while response = ssl_client.sysread(1000) # Read 1000 bytes at a time
      results = results + response
      break if (response.include?("</RESULT>"))
    end
    
    ssl_client.close
    
    data= Hash.from_xml(results.gsub(/&/, '/&amp;')) # Convert xml response to a hash, escaping ampersands first
    
    unless data["RESULT"]["ROW"].blank?
      if data["RESULT"]["ROW"].is_a? Hash # Only one result returned, so put it into an array
        return [data["RESULT"]["ROW"]]
      else
        return data["RESULT"]["ROW"]
      end
    else
      return [] # No images found
    end
  end
  
  ######################################################
  
  # Get all jpegger images for this company with this ticket number
  def self.api_find_all_by_ticket_number(ticket_number, company, yard_id)
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    # SQL command that gets sent to jpegger service
    command = "<FETCH><SQL>select * from images where ticket_nbr='#{ticket_number}' and yardid='#{yard_id}'</SQL><ROWS>1000</ROWS></FETCH>"
    
    # SSL TCP socket communication with jpegger
    tcp_client = TCPSocket.new host, port
    ssl_client = OpenSSL::SSL::SSLSocket.new tcp_client
    ssl_client.connect
    ssl_client.sync_close = true
    ssl_client.puts command
#    response = ssl_client.sysread(200000) # Read up to 200,000 bytes

    results = ""
    while response = ssl_client.sysread(1000) # Read 1000 bytes at a time
      results = results + response
#      puts response
      break if (response.include?("</RESULT>"))
    end
    
    ssl_client.close
    
#    Rails.logger.debug "***********Image.api_find_all_by_ticket_number results #{results}"
    data= Hash.from_xml(results.gsub(/&/, '/&amp;')) # Convert xml response to a hash, escaping ampersands first
    
    unless data["RESULT"]["ROW"].blank?
      if data["RESULT"]["ROW"].is_a? Hash # Only one result returned, so put it into an array
        return [data["RESULT"]["ROW"]]
      else
        return data["RESULT"]["ROW"]
      end
    else
      return [] # No images found
    end
    
  end
  
  # Get all the data for the image with this capture sequence number
  def self.api_find_by_capture_sequence_number(capture_sequence_number, company, yard_id)
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    # SQL command that gets sent to jpegger service
    command = "<FETCH><SQL>select * from images where capture_seq_nbr='#{capture_sequence_number}' and yardid='#{yard_id}'</SQL><ROWS>100</ROWS></FETCH>"
    
    # SSL TCP socket communication with jpegger
    tcp_client = TCPSocket.new host, port
    ssl_client = OpenSSL::SSL::SSLSocket.new tcp_client
    ssl_client.connect
    ssl_client.sync_close = true
    ssl_client.puts command
    response = ssl_client.sysread(200000) # Read up to 200,000 bytes
    ssl_client.close
    
    # Non-SSL TCP socket communication with jpegger
#    socket = TCPSocket.open(host,port) # Connect to server
#    socket.send(command, 0)
#    response = socket.recvfrom(200000)
#    socket.close
    
#    Rails.logger.debug "***********response: #{response}"
#    data= Hash.from_xml(response.first) # Get first element of array response and convert xml response to a hash
#    data= Hash.from_xml(response) # Convert xml response to a hash
    data= Hash.from_xml(response.gsub(/&/, '/&amp;')) # Convert xml response to a hash, escaping ampersands first
    
    unless data["RESULT"]["ROW"].blank?
      return data["RESULT"]["ROW"] # SQL response comes back in <RESULT><ROW>
    else
      return nil # No image found
    end

  end
  
  # Get all jpegger images for this company with this receipt number
  def self.api_find_all_by_receipt_number(receipt_number, company, yard_id)
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    # SQL command that gets sent to jpegger service
    command = "<FETCH><SQL>select * from images where receipt_nbr='#{receipt_number}' and yardid='#{yard_id}'</SQL><ROWS>100</ROWS></FETCH>"
    
    # SSL TCP socket communication with jpegger
    tcp_client = TCPSocket.new host, port
    ssl_client = OpenSSL::SSL::SSLSocket.new tcp_client
    ssl_client.connect
    ssl_client.sync_close = true
    ssl_client.puts command
    response = ssl_client.sysread(200000) # Read up to 200,000 bytes
    ssl_client.close
    
    Rails.logger.debug "*********** Image.api_find_all_by_receipt_number response: #{response}"
#    data= Hash.from_xml(response) # Convert xml response to a hash
    data= Hash.from_xml(response.gsub(/&/, '/&amp;')) # Convert xml response to a hash, escaping ampersands first
    
    unless data["RESULT"]["ROW"].blank?
      if data["RESULT"]["ROW"].is_a? Hash # Only one result returned, so put it into an array
        return [data["RESULT"]["ROW"]]
      else
        return data["RESULT"]["ROW"]
      end
    else
      return [] # No images found
    end
  end
  
  # Get first jpegger image for this company with this ticket number and event code
  def self.api_find_first_by_ticket_number_and_event_code(ticket_number, company, yard_id, event_code)
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    # SQL command that gets sent to jpegger service
    command = "<FETCH><SQL>SELECT TOP 1 [images].* from images where ticket_nbr='#{ticket_number}' and event_code='#{event_code}' and yardid='#{yard_id}'</SQL><ROWS>100</ROWS></FETCH>"
    
    # SSL TCP socket communication with jpegger
    tcp_client = TCPSocket.new host, port
    ssl_client = OpenSSL::SSL::SSLSocket.new tcp_client
    ssl_client.connect
    ssl_client.sync_close = true
    ssl_client.puts command
    response = ssl_client.sysread(200000) # Read up to 200,000 bytes
    ssl_client.close
    
    Rails.logger.debug "***********Image.api_find_first_by_ticket_number_and_event_code response: #{response}"
#    data= Hash.from_xml(response.first) # Convert xml response to a hash
#    data= Hash.from_xml(response) # Convert xml response to a hash
    data= Hash.from_xml(response.gsub(/&/, '/&amp;')) # Convert xml response to a hash, escaping ampersands first
    
    unless data["RESULT"]["ROW"].blank?
      return data["RESULT"]["ROW"]
    else
      return nil # No image found
    end
    
  end
  
  # Get all jpegger images for this company with this service request number
  def self.api_find_all_by_service_request_number(service_request_number, company, yard_id)
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    # SQL command that gets sent to jpegger service
    command = "<FETCH><SQL>select * from images where service_req_nbr='#{service_request_number}' and yardid='#{yard_id}'</SQL><ROWS>100</ROWS></FETCH>"
    
    # SSL TCP socket communication with jpegger
    tcp_client = TCPSocket.new host, port
    ssl_client = OpenSSL::SSL::SSLSocket.new tcp_client
    ssl_client.connect
    ssl_client.sync_close = true
    ssl_client.puts command
    response = ssl_client.sysread(200000) # Read up to 200,000 bytes
    ssl_client.close
    
    Rails.logger.debug "*********** Image.api_find_all_by_service_request_number response: #{response}"
#    data= Hash.from_xml(response) # Convert xml response to a hash
    data= Hash.from_xml(response.gsub(/&/, '/&amp;')) # Convert xml response to a hash, escaping ampersands first
    
    unless data["RESULT"]["ROW"].blank?
      if data["RESULT"]["ROW"].is_a? Hash # Only one result returned, so put it into an array
        return [data["RESULT"]["ROW"]]
      else
        return data["RESULT"]["ROW"]
      end
    else
      return [] # No images found
    end
  end
  
  # Get all jpegger images for this company with this ticket number
  def self.api_find_all_by_container_number_and_service_request_number(container_number, service_request_number, company, yard_id)
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    # SQL command that gets sent to jpegger service
    command = "<FETCH><SQL>select * from images where container_nbr='#{container_number}' and service_req_nbr='#{service_request_number}' and yardid='#{yard_id}'</SQL><ROWS>1000</ROWS></FETCH>"
    
    # SSL TCP socket communication with jpegger
    tcp_client = TCPSocket.new host, port
    ssl_client = OpenSSL::SSL::SSLSocket.new tcp_client
    ssl_client.connect
    ssl_client.sync_close = true
    ssl_client.puts command
#    response = ssl_client.sysread(200000) # Read up to 200,000 bytes

    results = ""
    while response = ssl_client.sysread(1000) # Read 1000 bytes at a time
      results = results + response
#      puts response
      break if (response.include?("</RESULT>"))
    end
    
    ssl_client.close
    
#    Rails.logger.debug "***********Image.api_find_all_by_container_number_and_service_request_number results #{results}"
    data= Hash.from_xml(results.gsub(/&/, '/&amp;')) # Convert xml response to a hash, escaping ampersands first
    
    unless data["RESULT"]["ROW"].blank?
      if data["RESULT"]["ROW"].is_a? Hash # Only one result returned, so put it into an array
        return [data["RESULT"]["ROW"]]
      else
        return data["RESULT"]["ROW"]
      end
    else
      return [] # No images found
    end
    
  end
  
  def self.jpeg_image_data_uri(jpeg_image)
    unless jpeg_image.blank?
      "data:image/jpg;base64, #{Base64.encode64(jpeg_image)}"
    else
      nil
    end
  end
  
  def self.latitude_and_longitude(company, capture_sequence_number, yard_id)
    require "open-uri"
    url = "https://#{company.jpegger_service_ip}:#{company.jpegger_service_port}/sdcgi?image=y&table=images&capture_seq_nbr=#{capture_sequence_number}&yardid=#{yard_id}"
    
    begin
      data = Exif::Data.new(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))

      latitude = data.gps_latitude
      longitude = data.gps_longitude
      latitude_ref = data.gps_latitude_ref
      longitude_ref = data.gps_longitude_ref

      latitude_decimal = latitude.blank? ? nil : (latitude[0] + latitude[1]/60 + latitude[2]/3600).to_f.round(6)
      longitude_decimal = longitude.blank? ? nil : (longitude[0] + longitude[1]/60 + longitude[2]/3600).to_f.round(6)

      unless latitude_decimal.blank? or longitude_decimal.blank?
        return "#{latitude_decimal} #{latitude_ref},#{longitude_decimal} #{longitude_ref}"
      else
        return ""
      end
    rescue => e
      Rails.logger.info "Image.latitude_and_longitude: #{e}"
      return ""
    end
  end
  
  def Image.google_map(center)
    return "https://www.google.com/maps/embed/v1/place?key=#{ENV['GOOGLE_MAPS_API_KEY']}&q=#{center}&zoom=19"
  end
  
end