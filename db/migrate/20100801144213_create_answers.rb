class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.column :user_id, :int
      t.column  :survey_id, :int
      t.timestamps
    end
  end


  def self.down
    drop_table :answers
  end
end
