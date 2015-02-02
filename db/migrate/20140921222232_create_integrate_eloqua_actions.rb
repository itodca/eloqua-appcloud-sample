class CreateIntegrateEloquaActions < ActiveRecord::Migration
  def change
    create_table :integrate_eloqua_actions do |t|
      t.integer :site_id
      t.string :instance_id
      t.string :lead_id_field
      t.string :disposition_code
      t.timestamps
    end
  end
end
