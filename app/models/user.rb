class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, 
         :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  validates :first_name, :last_name, :city, :country, presence: true
  validates :postal_code, presence: true, numericality: true
  # validates :phone_number, presence: true, numericality: true, length: { minimum: 10, maximum: 10 }

  enum user_type: { individual: 'individual', professional: 'professional' }

  validates :user_type, presence: true, inclusion: { in: user_types.keys }

  has_one_attached :profile_picture
  has_one_attached :passport_document
  has_one_attached :identity_card_document

  has_many :parcel_ads, dependent: :destroy
  has_many :travelers, dependent: :destroy
  has_many :buy_for_mes, dependent: :destroy
  
  # for chat feature
  has_and_belongs_to_many :chat_rooms
  has_many :messages
  has_many :reactions

  # Users who give reviews
  has_many :given_reviews, class_name: 'Review', foreign_key: 'reviewer_id', dependent: :destroy

  # Users who receive reviews
  has_many :received_reviews, class_name: 'Review', foreign_key: 'reviewee_id', dependent: :destroy 


  # for phone number verification with twilio
  def masked_phone_number
    return nil if phone_number.blank?
    phone_number[0..2] + '****' + phone_number[6..-1]
  end

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

  def find_or_create_chat_room_with(other_user)
    # Check if the chat room already exists for the two users.
    chat_room = chat_rooms.joins(:users)
                          .where(users: { id: other_user.id })
                          .first

    # Return the existing chat room if found.
    return chat_room if chat_room

    # Otherwise, create a new chat room and add the users to it.
    ChatRoom.create.tap do |room|
      room.users << [self, other_user]
    end
  end
end

