class CreateWordNets < ActiveRecord::Migration[6.1]
  def change
    create_table :word_nets do |t|
      t.string :keyword

      t.timestamps
    end
  end
end
