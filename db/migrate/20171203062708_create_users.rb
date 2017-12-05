class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|

      t.string :phone, comment: '手机号码'
      t.string :password, comment: '密码'
      t.datetime :start_time, comment: '开始时间'
      t.datetime :end_time, comment: '结束时间'
      t.integer :status, comment: '0: 禁用 1:可用'
      t.timestamps
    end
  end
end
