class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.string :name
      t.text :description
      t.references :project, foreign_key: true, index: true

      t.timestamps
    end
  end
end
