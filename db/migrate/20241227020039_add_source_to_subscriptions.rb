class AddSourceToSubscriptions < ActiveRecord::Migration[7.1]
  def change
    add_column :subscriptions, :source, :string, default: 'stripe'
    add_index :subscriptions, :source
  end
end
