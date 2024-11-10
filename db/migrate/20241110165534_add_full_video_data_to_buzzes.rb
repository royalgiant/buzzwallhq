class AddFullVideoDataToBuzzes < ActiveRecord::Migration[7.1]
  def change
    add_column :buzzes, :full_video_data, :json
  end
end
