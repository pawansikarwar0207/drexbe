class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, 
         # :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # validates :first_name, :last_name, :city, :country, presence: true
  # validates :postal_code, presence: true, numericality: true
  # validates :phone_number, presence: true, numericality: true, length: { minimum: 10, maximum: 10 }

  has_one_attached :profile_picture
  has_one_attached :passport_document
  has_one_attached :identity_card_document

  has_many :parcel_ads, dependent: :destroy

  def profile_completion
    completion = 0

    completion += 20 if profile_picture.attached?
    completion += 30 if phone_number.present?
    completion += 30 if passport_document.attached? || identity_card_document.attached?

    # Add 20% if the email is confirmed
    completion += 20 if confirmed?

    completion
  end

  def verified?
    profile_completion == 100
  end

  def confirmed?
    self.confirmed_at.present?
  end

  def masked_phone_number
    if phone_number.present?
      # Assuming phone number has at least 10 digits, you can adjust this as needed
      phone_number.gsub(/.(?=.{4})/, 'X') # Mask all but the last 4 digits
    else
      nil
    end
  end

  # omniauth login using google
  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    unless user
      user = User.create(
        email: data['email'],
        password: 'password' ,
        first_name: data['first_name'],
        last_name: data['last_name']
       )
    end
    user
  end

  def full_name
    "#{first_name} #{last_name} "
  end

  def address
    "#{city} #{country}"
  end

end

