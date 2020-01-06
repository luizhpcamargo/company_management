require 'rails_helper'

RSpec.describe Employee, type: :model do
  context 'relations' do
    it { is_expected.to belong_to :company }
  end

  context 'validations' do
    it { is_expected.to validate_uniqueness_of :document }

    context '#document' do
      context 'when cpf is invalid' do
        subject { described_class.new(document: '12345678900', company: Company.new) }

        it { is_expected.to be_invalid }
      end

      context 'when cpf is valid' do
        subject { described_class.new(document: CPF.generate, company: Company.new) }

        it { is_expected.to be_valid }
      end
    end
  end
end
