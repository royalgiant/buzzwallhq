class CreateBuzzTerms < ActiveRecord::Migration[7.0]
  def change
    create_table :buzz_terms do |t|
      t.string :term, null: false
      t.references :user, null: false, foreign_key: true
      t.string :frequency_check, null: false, default: 'daily' 

      t.timestamps
    end
  end
end
