class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :user_name
      t.string   :email
      t.string   :first_name
      t.string   :last_name
      t.datetime :created_at
      t.datetime :last_login
      t.string   :last_login_ip
      t.string   :address1
      t.string   :address2
      t.string   :city
      t.string   :state
      t.string   :zip
      t.string   :phone
      t.string   :phone2
      t.string   :fax
      t.string   :country
      t.text     :notes
      t.string   :preferences
      t.string   :time_zone
      t.string   :time_local 
      t.string   :timezone_offset 
      t.integer  :bolt_identity_id
    end
  end

  def self.down
    drop_table :users
  end
end
