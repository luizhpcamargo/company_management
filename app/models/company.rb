class Company < ApplicationRecord
  has_many :employees
  validates_uniqueness_of :document
  validate :document_valid?

  private

  def document_valid?
    errors.add(:document, 'is invalid') unless CNPJ.valid?(document)
  end
end
