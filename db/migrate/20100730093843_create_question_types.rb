class CreateQuestionTypes < ActiveRecord::Migration
  def self.up
    create_table :question_types do |t|
      t.column :question_type, :string
      t.timestamps
    end
    execute("insert into question_types values ('1','free_text_response','2010-07-30 15:00:00','2010-07-30 15:00:00')")
    execute("insert into question_types values ('2','Multiple choice with one possible response','2010-07-30 15:00:00','2010-07-30 15:00:02')")
    execute("insert into question_types values ('3','Multiple choice with more than one possible response','2010-07-30 15:00:00','2010-07-30 15:00:03')")
  end

  def self.down
    drop_table :question_types
  end
end
