class CreateSrakas < ActiveRecord::Migration[6.1]
  def change
    create_table :srakas do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
