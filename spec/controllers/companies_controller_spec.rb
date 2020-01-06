require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  let(:company_params) do
    {
      name: 'Razão',
      company_name: 'Fantasia',
      document: CNPJ.generate
    }
  end

  let(:params) do
    {
      company: company_params
    }
  end

  let(:body) { JSON.parse(response.body) }

  context '#create' do
    let(:creation) { post :create, params: params }

    it { expect { creation }.to change{ Company.count }.by(1) }

    context 'before creation' do
      before { creation }

      it { expect(response).to be_created }
      it { expect { post :create, params: params }.to_not change{ Company.count } }
      it { expect(response.code).to eq '201' }

      context 'calling two times' do
        before { post :create, params: params }

        it { expect(response).to_not be_ok }
        it { expect(body['errors']).to eq ['Document has already been taken'] }
        it { expect(response.code).to eq '304' }
      end
    end
  end

  context '#show' do
    let!(:company) { Company.create(company_params) }

    before { get :show, params: {id: company.id} }

    it { expect(response).to be_ok }
    it { expect(body['id']).to eq company.id }
    it { expect(response.code).to eq '200' }

    context 'not found' do
      before { get :show, params: { id: 'a' } }

      it { expect(response).to_not be_ok }
      it { expect(body['errors']).to eq ['Company not found']}
      it { expect(response.code).to eq '404' }
    end

    context 'with employees' do
      let!(:employee) { company.employees.create(name: 'Func', document: CPF.generate, birth: '1990-02-01') }
      let(:parsed_employee) { JSON.parse(employee.to_json) }

      before do
        get :show, params: { id: company.id, with_employees: true }
      end

      it { expect(body['employees'][0]).to match parsed_employee }
    end
  end

  context '#index' do
    before { get :index }

    it { expect(body.size).to eq 0 }
    it { expect(body).to be_a Array }
    it { expect(response).to be_ok }
    it { expect(response.code).to eq '200' }

    context 'with content' do
      let!(:company) { Company.create(document: CNPJ.generate) }
      let!(:companies) { 3.times { Company.create(document: CNPJ.generate) } }

      before { get :index }

      it { expect(body.size).to eq 4 }
      it { expect(body).to be_a Array }
      it { expect(response).to be_ok }
      it { expect(response.code).to eq '200' }

      context 'with employees' do
        let!(:employee) { company.employees.create(name: 'Func', document: CPF.generate, birth: '1990-02-01') }
        let(:parsed_employee) { JSON.parse(employee.to_json) }

        before { get :index, params: { id: company.id, with_employees: true } }

        it { expect(body[0]['employees'][0]).to match parsed_employee }
      end
    end
  end

  context '#destroy' do
    let!(:company) { Company.create(company_params) }

    it { expect{ put :destroy, params: { id: company.id } }.to change{ Company.count}.by(-1) }

    context 'messages and status' do
      before { put :destroy, params: {id: company.id} }

      it { expect(response).to be_ok }
      it { expect(body['message']).to eq 'Company destroyed' }
      it { expect(response.code).to eq '200' }
    end

    context 'not found' do
      before { put :destroy, params: { id: 'a' } }

      it { expect(response).to_not be_ok }
      it { expect(body['errors']).to eq ['Company not found']}
      it { expect(response.code).to eq '404' }
    end
  end

  context '#update' do
    let!(:company) { Company.create(company_params) }
    let(:update) { put :update, params: {id: company.id, company: { name: 'Razão 2' }} }

    it { expect { update }.to_not change{ Company.count } }
    it { expect { update }.to change { company.reload.name }.from('Razão').to('Razão 2') }
  end
end
