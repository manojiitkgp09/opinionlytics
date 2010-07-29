class CreateApps < ActiveRecord::Migration
  def self.up
    create_table :apps do |t|
      t.string :appname
      t.column :role, :boolean, :default => '0'
      t.timestamps
    end
  execute( "insert into apps (appname,role) values('opinionlytics','1')")
  end

  
  def self.down
    drop_table :apps
  end
end
