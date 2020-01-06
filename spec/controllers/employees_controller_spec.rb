require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  let(:company) { Company.create(document: CNPJ.generate) }
  let(:employee_params) do
    {
      name: 'Funcionário',
      company_id: company.id,
      birth: '1980-08-01',
      document: CPF.generate
    }
  end

  let(:params) do
    {
      employee: employee_params
    }
  end

  let(:body) { JSON.parse(response.body) }
  let(:parsed_company) { JSON.parse company.to_json }

  context '#create' do
    let(:creation) { post :create, params: params }

    it { expect { creation }.to change{ Employee.count }.by(1) }

    context 'before creation' do
      before { creation }

      it { expect(response).to be_created }
      it { expect { post :create, params: params }.to_not change{ Employee.count } }
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
    let!(:employee) { Employee.create(employee_params) }

    before { get :show, params: {id: employee.id} }

    it { expect(response).to be_ok }
    it { expect(body['id']).to eq employee.id }
    it { expect(response.code).to eq '200' }

    context 'not found' do
      before { get :show, params: { id: 'a' } }

      it { expect(response).to_not be_ok }
      it { expect(body['errors']).to eq ['Employee not found']}
      it { expect(response.code).to eq '404' }
    end

    context 'with_company' do
      before { get :show, params: { id: employee.id, with_company: true } }
      it { expect(body['company']).to match parsed_company }
    end
  end

  context '#index' do
    before { get :index }

    it { expect(body.size).to eq 0 }
    it { expect(body).to be_a Array }
    it { expect(response).to be_ok }
    it { expect(response.code).to eq '200' }

    context 'with content' do
      before do
        4.times { Employee.create(document: CPF.generate, company_id: company.id ) }
        get :index
      end

      it { expect(body.size).to eq 4 }
      it { expect(body).to be_a Array }
      it { expect(response).to be_ok }
      it { expect(response.code).to eq '200' }

      context 'with_company' do
        before { get :index, params: { with_company: true } }
        it { expect(body[0]['company']).to match parsed_company }
      end
    end
  end

  context '#destroy' do
    let!(:employee) { Employee.create(employee_params) }

    it { expect{ put :destroy, params: { id: employee.id } }.to change{ Employee.count}.by(-1) }

    context 'messages and status' do
      before { put :destroy, params: {id: employee.id} }

      it { expect(response).to be_ok }
      it { expect(body['message']).to eq 'Employee destroyed' }
      it { expect(response.code).to eq '200' }
    end

    context 'not found' do
      before { put :destroy, params: { id: 'a' } }

      it { expect(response).to_not be_ok }
      it { expect(body['errors']).to eq ['Employee not found']}
      it { expect(response.code).to eq '404' }
    end
  end

  context '#update' do
    let!(:employee) { Employee.create(employee_params) }
    let(:update) { put :update, params: {id: employee.id, employee: { name: 'Funcionário 2' }} }

    it { expect { update }.to_not change{ Employee.count } }
    it { expect { update }.to change { employee.reload.name }.from('Funcionário').to('Funcionário 2') }
  end
end
