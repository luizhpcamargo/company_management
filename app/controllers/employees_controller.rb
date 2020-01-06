class EmployeesController < ApplicationController
  before_action :load_employee, only: %i[show destroy update]

  def create
    employee = Employee.new(employee_params)

    if employee.save
      render json: employee.to_json, status: 201
    else
      render json: { errors: employee.errors.full_messages}.to_json, status: 304
    end
  end

  def show
    if @employee.present?
      render json: @employee.to_json, status: 200
    else
      render json: { errors: ['Employee not found'] }.to_json, status: 404
    end
  end

  def index
    employees = Employee.all

    render json: employees.to_json, status: 200
  end

  def destroy
    if @employee.present? && @employee.destroy
      render json: { message: 'Employee destroyed' }, status: 200
    else
      render json: { errors: ['Employee not found'] }.to_json, status: 404
    end
  end

  def update
    if @employee.update(employee_params)
      render json: @employee.to_json, status: 200
    else
      render json: { errors: @employee.errors.full_messages}.to_json, status: 304
    end
  end

  private

  def load_employee
    @employee = Employee.find_by(id: params[:id])
  end

  def employee_params
    params.require(:employee).permit(:name, :company_id, :birth, :document)
  end
end
