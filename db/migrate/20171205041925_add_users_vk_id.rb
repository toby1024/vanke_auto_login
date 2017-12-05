class AddUsersVkId < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :vk_id, :string, comment: '万科经纪人id'
  end
end
