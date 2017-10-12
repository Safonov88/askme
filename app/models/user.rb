require 'openssl'

class User < ApplicationRecord
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new
  has_many :questions

  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true
  validates :username, length: {maximum: 40}
  validates :username, format: {with: /[a-zA-Z0-9_]/,
                                message: "только латинские буквы, цифры, и знак _"}
  validates :email, format: {with: /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b/,
                             message: "некорректный адрес"}

  attr_accessor :password

  validates_presence_of :password, on: :create
  validates_confirmation_of :password

  before_validation :username_downcase
  before_save :encrypt_password

  def username_downcase
    self.username = self.username.downcase unless self.username.nil?
  end

  def encrypt_password
    if self.password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))
      self.password_hash = User.hash_to_string(OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.password_salt, ITERATIONS, DIGEST.length, DIGEST))
    end
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email)

    if user.present? && user.password_hash == User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(password, user.password_salt, ITERATIONS,
                                 DIGEST.length, DIGEST))
      user
    else
      nil
    end
  end
end
