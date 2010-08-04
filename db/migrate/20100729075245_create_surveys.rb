class CreateSurveys < ActiveRecord::Migration
  def self.up
    create_table :surveys do |t|
      t.column :title, :string 
      t.column :description, :string
      t.column :survey_category, :string
      t.column :status, :boolean, :default => '1'
      t.column :user_id, :int
      t.timestamps
    end
  end

  def self.down
    drop_table :surveys
  end
end
