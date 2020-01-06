require 'rails_helper'

RSpec.describe Company, type: :model do
  context 'relations' do
    it { is_expected.to have_many :employees }
  end

  context 'validations' do
    it { is_expected.to validate_uniqueness_of :document }

    context '#document' do
      context 'when cpf is invalid' do
        subject { described_class.new(document: '12345678901200') }

        it { is_expected.to be_invalid }
      end

      context 'when cpf is valid' do
        subject { described_class.new(document: CNPJ.generate) }

        it { is_expected.to be_valid }
      end
    end
  end
end
