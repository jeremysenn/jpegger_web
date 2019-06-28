require "administrate/base_dashboard"

class ImageFileDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    id: Field::Number,
    name: Field::String,
    file: Field::String,
    ticket_number: Field::String,
    customer_number: Field::String,
    customer_name: Field::String,
    branch_code: Field::String,
    location: Field::String,
    event_code: Field::String,
    event_code_id: Field::Number,
    image_id: Field::Number,
    container_number: Field::String,
    booking_number: Field::String,
    contract_number: Field::String,
    hidden: Field::Boolean,
    tare_seq_nbr: Field::String,
    commodity_name: Field::String,
    weight: Field::String.with_options(searchable: false),
    tag_number: Field::String,
    vin_number: Field::String,
    yard_id: Field::String,
    contract_verbiage: Field::String,
    service_request_number: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :user,
    :id,
    :name,
    :file,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :id,
    :name,
    :file,
    :ticket_number,
    :customer_number,
    :customer_name,
    :branch_code,
    :location,
    :event_code,
    :event_code_id,
    :image_id,
    :container_number,
    :booking_number,
    :contract_number,
    :hidden,
    :tare_seq_nbr,
    :commodity_name,
    :weight,
    :tag_number,
    :vin_number,
    :yard_id,
    :contract_verbiage,
    :service_request_number,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :name,
    :file,
    :ticket_number,
    :customer_number,
    :customer_name,
    :branch_code,
    :location,
    :event_code,
    :event_code_id,
    :image_id,
    :container_number,
    :booking_number,
    :contract_number,
    :hidden,
    :tare_seq_nbr,
    :commodity_name,
    :weight,
    :tag_number,
    :vin_number,
    :yard_id,
    :contract_verbiage,
    :service_request_number,
  ].freeze

  # Overwrite this method to customize how image files are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(image_file)
  #   "ImageFile ##{image_file.id}"
  # end
end
