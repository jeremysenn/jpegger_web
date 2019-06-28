class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :lockable, :trackable
  
  ROLES = %w[admin basic external].freeze
  
  belongs_to :company
  
  #############################
  #     Instance Methods      #
  #############################
  
  def full_name
    unless self.first_name.blank? and self.last_name.blank?
      "#{first_name} #{last_name}"
    else
      unless customer.blank?
        customer.full_name
      else
        "First Last"
      end
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
  
  #############################
  #     Class Methods         #
  #############################
  
end
