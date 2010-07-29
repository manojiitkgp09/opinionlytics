class Adminuser < ActiveRecord::Migration
  def self.up
execute("INSERT INTO users (name, salt, created_at, activated_at, crypted_password, remember_token_expires_at, updated_at, deleted_at, activation_code, remember_token, login, email, state) VALUES('admin', '0fbf75fb30c1e708982186e9b93efb9a1d728624', '2010-07-29 07:10:59.185795', NULL, '61c4155f9903e69e39c37e9eb684d94039a62020', NULL, '2010-07-29 07:10:59.185795', NULL, '564f320007bdfe3f7de83902a322d639d7c7c610', NULL, 'admin', 'admin@opinionlytics.com', 'active')")

  end

  def self.down
execute("delete from users where id ='6' ") 
  end
end
