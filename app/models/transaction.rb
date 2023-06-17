class Transaction < ApplicationRecord
  enum status: [:posted, :pending]

  belongs_to :account
end
