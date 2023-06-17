class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :connections, dependent: :destroy
  has_many :accounts, through: :connections, dependent: :destroy

  def gateway_user?
    # gateway_id.present? && !gateway_user_blocked?
    gateway_id.present?
  end

  # def gateway_user_blocked?
  #   gateway_blocked_at.present? && gateway_blocked_at <= DateTime.current
  # end
end
