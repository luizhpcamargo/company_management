class CompaniesController < ApplicationController
  def create
    company = Company.new(company_params)

    if company.save
      render json: company.to_json, status: 200
    else
      render json: { errors: company.errors.full_messages}.to_json, status: 301
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :company_name, :document)
  end
end
