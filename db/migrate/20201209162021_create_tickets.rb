class CreateTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :tickets do |t|
      t.integer :available
      t.decimal :price, precision: 8, scale: 2
      t.belongs_to :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
