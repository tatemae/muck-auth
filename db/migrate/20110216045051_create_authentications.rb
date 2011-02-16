class CreateAuthentications < ActiveRecord::Migration
  def self.up
    create_table :authentications do |t|
      t.integer :authenticatable_id
      t.string :authenticatable_type
      t.string :provider
      t.string :uid
      t.string :name
      t.string :nickname
      t.string :token
      t.string :secret
      t.text :raw_auth
      t.timestamps
    end
    add_index :authentications, [:authenticatable_id, :authenticatable_type], :name => 'authenticatable'
  end

  def self.down
    drop_table :authentications
  end
end