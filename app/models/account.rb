class Account < ApplicationRecord
  belongs_to :connection, counter_cache: true
end
