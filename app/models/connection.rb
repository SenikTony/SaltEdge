class Connection < ApplicationRecord
  enum status: [:active, :inactive, :disabled]

  belongs_to :user

  has_many :accounts, dependent: :destroy
  has_many :transactions, through: :accounts
end
