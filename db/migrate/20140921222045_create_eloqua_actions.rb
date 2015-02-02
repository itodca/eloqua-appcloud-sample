class CreateEloquaActions < ActiveRecord::Migration
  def change
    create_table :eloqua_actions do |t|

      t.timestamps
    end
  end
end
