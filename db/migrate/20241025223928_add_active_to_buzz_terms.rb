class AddActiveToBuzzTerms < ActiveRecord::Migration[7.1]
  def change
    add_column :buzz_terms, :active, :boolean, default: true, null: false
  end
end
