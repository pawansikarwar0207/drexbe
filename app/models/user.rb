class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  validates :first_name, :last_name, :city, :country, presence: true
  validates :postal_code, presence: true, numericality: true
  validates :phone_number, presence: true, numericality: true, length: { minimum: 10, maximum: 10 }
end
