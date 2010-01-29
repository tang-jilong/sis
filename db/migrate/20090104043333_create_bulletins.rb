class CreateBulletins < ActiveRecord::Migration
  def self.up
    create_table :bulletins do |t|
      t.string :title
      t.datetime :issue_date
      t.text :content
      t.string :autor
      t.string :file_name

      t.timestamps
    end
  end

  def self.down
    drop_table :bulletins
  end
end
