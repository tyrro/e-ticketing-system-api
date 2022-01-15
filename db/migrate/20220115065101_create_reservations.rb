class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.integer :status, null: false, default: 0
      t.integer :tickets_count
      t.decimal :tickets_total_price, precision: 8, scale: 2
      t.belongs_to :event, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
