class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
    	t.string :order
    	t.string :item
    	t.string :number
    	t.string :name
    	t.string :money
      t.string :balance
      t.boolean :deleted, default: false

      t.timestamps null: false
    end
  end
end
