class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.column :question_details, :string
      t.column :questiontype_id, :int
      t.column :choice_details, :string, :default => "xxx"
      t.column :status, :boolean, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
