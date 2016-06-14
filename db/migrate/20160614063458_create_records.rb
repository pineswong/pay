class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
    	t.string :order
    	t.string :type
    	t.string :number
    	t.string :name
    	t.string :money
    	t.string :balance

      t.timestamps null: false
    end
  end
end
