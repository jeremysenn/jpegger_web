class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :lockable, :trackable
  
  ROLES = %w[admin basic external].freeze
  
  belongs_to :company
  
  accepts_nested_attributes_for :company
  
  #############################
  #     Instance Methods      #
  #############################
  
  def full_name
    unless self.first_name.blank? and self.last_name.blank?
      "#{first_name} #{last_name}"
    else
      "First Last"
    end
  end
  
  def admin?
    role == "admin"
  end
  
  def external?
    role == "external"
  end
  
  def super?
    role == "super"
  end
  
  def domain_from_email
    self.email[/(?<=@)[^.]+/]
  end
  
  #############################
  #     Class Methods         #
  #############################
  
  def self.domain_from_email(email_address)
    email_address[/(?<=@)[^.]+/]
  end
  
end
