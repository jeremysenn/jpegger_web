class SaveSearchWorker
  include Sidekiq::Worker
  
  def perform(user_id, table_name, event_code, customer_name, ticket_number, start_date, end_date)
    Search.create(user_id: user_id, table_name: table_name, event_code: event_code, customer_name: customer_name, ticket_number: ticket_number, start_date: start_date, end_date: end_date)
  end
  
end