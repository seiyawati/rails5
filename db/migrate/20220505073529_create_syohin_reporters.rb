class CreateSyohinReporters < ActiveRecord::Migration[5.2]
  def change
    create_table :syohin_reporters do |t|
      t.string :type

      t.string :name
      t.string :email
      t.string :company

      t.timestamps
    end
  end
end
