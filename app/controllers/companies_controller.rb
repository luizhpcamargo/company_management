class CompaniesController < ApplicationController
  before_action :load_company, only: %i[show destroy update]

  def create
    company = Company.new(company_params)

    if company.save
      render json: company.to_json, status: 201
    else
      render json: { errors: company.errors.full_messages}.to_json, status: 304
    end
  end

  def show
    if @company.present?
      result = if params[:with_employees]
                 @company.to_json(include: :employees)
               else
                 @company.to_json
               end
      render json: result, status: 200
    else
      render json: { errors: ['Company not found'] }.to_json, status: 404
    end
  end

  def index
    companies = if params[:with_employees]
                  Company.includes(:employees).references(:employees).all.to_json(include: :employees)
                else
                  Company.all.to_json
                end
    render json: companies, status: 200
  end

  def destroy
    if @company.present? && @company.destroy
      render json: { message: 'Company destroyed' }, status: 200
    else
      render json: { errors: ['Company not found'] }.to_json, status: 404
    end
  end

  def update
    if @company.update(company_params)
      render json: @company.to_json, status: 200
    else
      render json: { errors: @company.errors.full_messages}.to_json, status: 304
    end
  end

  private

  def load_company
    @company = Company.find_by(id: params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :company_name, :document)
  end
end
