class Borrower < ApplicationRecord
  has_secure_password
  has_many :histories

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  validates :first_name, :last_name, presence: true, length: {in: 2..100}
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }
  validates :password, presence: true, length: {in: 2..100}
  validates :money, presence: true, numericality: {greater_than: 0}
  validates :purpose, presence: true, length: {in: 2..200}
  validates :description, presence: true, length: {in: 2..200}

  before_save do
		self.email.downcase!	
	end
end
