class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :company_name
      t.string :document
      t.timestamps
    end

    add_index :companies, :document, unique: true
  end
end
