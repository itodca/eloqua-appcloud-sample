class CreateEloquaInstances < ActiveRecord::Migration
  def change
    create_table :eloqua_instances do |t|
      t.string :site_id
      t.string :site_name
      t.string :client_id
      t.string :access_token
      t.datetime :token_expiry
      t.string :refresh_token
      t.timestamps
    end
  end
end
