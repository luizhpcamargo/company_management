class Employee < ApplicationRecord
  belongs_to :company
  validates_uniqueness_of :document
  validate :document_valid?

  private

  def document_valid?
    errors.add(:document, 'is not valid') unless CPF.valid?(document)
  end
end
