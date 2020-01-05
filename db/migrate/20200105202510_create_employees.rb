class CreateEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table :employees do |t|
      t.references :company
      t.string :name
      t.string :document
      t.date :birth
      t.timestamps
    end

    add_index :employees, :document, unique: true
  end
end
