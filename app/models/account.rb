class Account < ApplicationRecord
  belongs_to :connection, counter_cache: true

  has_many :transactions, dependent: :destroy
end
