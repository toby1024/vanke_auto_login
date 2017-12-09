class AddWxopenidToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :wxopenid, :string, comment: '微信openid'
  end
end
