class CreateDistributionCenterProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :distribution_center_products do |t|
      t.references :distribution_center, foreign_key: true
      t.references :product, foreign_key: true
      t.timestamps
    end
  end
end
