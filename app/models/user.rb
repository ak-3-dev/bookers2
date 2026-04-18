class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :books, dependent: :destroy
  has_one_attached :profile_image

  def get_prpfile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join("app/assets/image/no_image.jog")
      profile_image.attach(io: File.open(file_path), filename: "default-image.jpg", content_type: "image/jpeg")
    end

    profile_image.variant(resize_to_limit: [width, height]).processed

  validates :introduction, length: { maximum: 50 }  

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
