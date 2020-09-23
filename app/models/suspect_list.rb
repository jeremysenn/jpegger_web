class SuspectList < ApplicationRecord
  belongs_to :user
  belongs_to :company
  
  mount_uploader :file, SuspectListFileUploader
end
