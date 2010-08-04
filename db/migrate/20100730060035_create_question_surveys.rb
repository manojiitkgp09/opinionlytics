class CreateQuestionSurveys < ActiveRecord::Migration
  def self.up
    create_table :question_surveys do |t|
      t.column :question_id, :int
      t.column :survey_id, :int
      t.timestamps
    end
  end

  def self.down
    drop_table :question_surveys
  end
end
