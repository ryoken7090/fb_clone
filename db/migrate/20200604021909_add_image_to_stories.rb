class AddImageToStories < ActiveRecord::Migration[5.2]
  def change
    add_column :stories, :image, :text
  end
end
