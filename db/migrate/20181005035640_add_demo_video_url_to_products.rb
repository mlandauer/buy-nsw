class AddDemoVideoUrlToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :demo_video_url, :text
  end
end
