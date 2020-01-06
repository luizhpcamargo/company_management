require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  let(:params) do
    {
      company:
      {
        name: 'Razão',
        company_name: 'Fantasia',
        document: CNPJ.generate
      }
    }
  end

  context '#create' do
    let(:creation) { post :create, params: params }

    it { expect { creation }.to change{ Company.count }.by(1) }

    context 'before creation' do
      before { creation }

      it { expect(response).to be_created }
      it { expect { post :create, params: params }.to_not change{ Company.count } }
      it { expect(response.code).to eq '201' }

      context 'calling two times' do
        let(:body) { JSON.parse(response.body) }
        before { post :create, params: params }

        it { expect(response).to_not be_ok }
        it { expect(body['errors']).to eq ['Document has already been taken'] }
        it { expect(response.code).to eq '304' }
      end
    end
  end
end
