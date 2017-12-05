class CreateUserPoints < ActiveRecord::Migration[5.1]
  def change
    create_table :user_points do |t|

      t.references :user
      t.integer :point, comment: "积分"
      t.integer :status, comment: "0:历史记录 1：最新记录"
      t.timestamps
    end
  end
end
