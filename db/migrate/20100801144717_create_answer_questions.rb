class CreateAnswerQuestions < ActiveRecord::Migration
  def self.up
    create_table :answer_questions do |t|
      t.column :question_id, :int
      t.column :answer_id, :int
      t.string :answer_text
      t.timestamps
    end
  end

  def self.down
    drop_table :answer_questions
  end
end
