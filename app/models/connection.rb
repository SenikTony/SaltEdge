class Connection < ApplicationRecord
  enum status: [:active, :inactive, :disabled]

  belongs_to :user
end
