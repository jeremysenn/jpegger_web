class LookupDef
  
  def self.all_for_images_table(user)
    company = Company.find(user.company_id)
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    # SQL command that gets sent to jpegger service
    command = "<FETCH><SQL>select * from LookupDefs where TABLENAME='images'</SQL><ROWS>1000</ROWS></FETCH>"
    
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
      return [] # None
    end
  end
  
  def self.all_for_shipments_table(user)
    company = Company.find(user.company_id)
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    # SQL command that gets sent to jpegger service
    command = "<FETCH><SQL>select * from LookupDefs where TABLENAME='shipments'</SQL><ROWS>1000</ROWS></FETCH>"
    
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
      return [] # None
    end
  end
  
  def self.image_event_codes(user)
    company = Company.find(user.company_id)
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    # SQL command that gets sent to jpegger service
    command = "<FETCH><SQL>select LOOKUPDISPLAY from LookupDefs where TABLENAME='images_data' and (FIELDNAME='event_code')</SQL><ROWS>1000</ROWS></FETCH>"
    
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
        return [data["RESULT"]["ROW"]].map{|l| l["LOOKUPDISPLAY"]}.reject(&:nil?)
      else
        return data["RESULT"]["ROW"].map{|l| l["LOOKUPDISPLAY"]}.reject(&:nil?)
      end
    else
      return [] # None
    end
  end
  
end