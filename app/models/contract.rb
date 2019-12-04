class Contract

#  self.table_name = 'contracts'
#  self.primary_key = 'contract_id'
  
  #############################
  #     Instance Methods      #
  ############################
  
  
  #############################
  #     Class Methods         #
  #############################
  
  def self.all(user)
    company = Company.find(user.company_id)
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    # SQL command that gets sent to jpegger service
    command = "<FETCH><SQL>select * from contracts</SQL><ROWS>100</ROWS></FETCH>"
    
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
        return [data["RESULT"]["ROW"]].map{|c| [c["TEXT1"], c["CONTRACT_ID"]]}.reject(&:nil?)
      else
        return data["RESULT"]["ROW"].map{|c| [c["TEXT1"], c["CONTRACT_ID"]]}.reject(&:nil?)
      end
    else
      return [] # None
    end
    
  end
  
  def self.find_by_contract_number(contract_number, user)
    company = user.company
    require 'socket'
    host = company.jpegger_service_ip
    port = company.jpegger_service_port
    
    # SQL command that gets sent to jpegger service
    command = "<FETCH><SQL>select * from contracts where contract_id LIKE '%#{contract_number}%'</SQL><ROWS>100</ROWS></FETCH>"
    
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
    Rails.logger.debug "********* Contract.find_by_contract_number response: #{results}"
    
    data= Hash.from_xml(results.gsub(/&/, '/&amp;')) # Convert xml response to a hash, escaping ampersands first
    
    unless data["RESULT"]["ROW"].blank?
      return data["RESULT"]["ROW"] # SQL response comes back in <RESULT><ROW>
    else
      return nil # No contract found
    end
  end

end

