class CreateFulfillmentCenters < ActiveRecord::Migration[6.0]
  def change
    create_table :fulfillment_centers do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
