class Answer < ActiveRecord::Base

  belongs_to :users
  belongs_to :surveys
  has_many :questions, :through => :answer_questions

 validates_uniqueness_of :user_id, :scope => [:survey_id] 

end
