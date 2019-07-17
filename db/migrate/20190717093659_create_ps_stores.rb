class CreatePsStores < ActiveRecord::Migration[5.2]
  def change
    create_table :ps_stores do |t|
      t.integer :id_store
      t.integer :id_country
      t.integer :id_state
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :postcode
      t.decimal :lalitude, precision: 13, scale: 8
      t.decimal :longitude, precision: 13, scale: 8
      t.string :hours
      t.string :phone
      t.string :fax
      t.string :email
      t.text :note
      t.binary :active
      t.string :layer
      t.datetime :date_add
      t.datetime :date_upd

      t.timestamps
    end
    add_index :ps_stores, :id_country
    add_index :ps_stores, :id_state
  end
end
