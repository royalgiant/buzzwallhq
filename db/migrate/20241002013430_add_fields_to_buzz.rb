class AddFieldsToBuzz < ActiveRecord::Migration[7.0]
  def change
    add_column :buzzs, :video_id, :string
    add_column :buzzs, :title, :string
    add_column :buzzs, :play_count, :integer
    add_column :buzzs, :comment_count, :integer
    add_column :buzzs, :share_count, :integer
    add_column :buzzs, :create_time, :datetime
    add_column :buzzs, :author, :json
  end
end
