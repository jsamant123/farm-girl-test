class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto'

    create_table :orders, id: :uuid do |t|
      t.integer :status, default: 0
      t.references :fulfiller, polymorphic: true
      t.timestamps

      # adds indexing to status field
      t.index :status
    end
  end
end
