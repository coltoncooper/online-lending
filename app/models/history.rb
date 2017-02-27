class History < ApplicationRecord
  belongs_to :lender
  belongs_to :borrower

  validates :amount, presence: true, numericality: {greater_than: 0}
end
