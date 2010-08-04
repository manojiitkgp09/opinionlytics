class Question < ActiveRecord::Base
 
  validates_presence_of :question_details 
  validates_presence_of :choice_details


  has_many :answers, :dependent => :delete_all
  has_many :question_surveys, :dependent => :delete_all
  has_many :surveys, :through => :question_surveys
  belongs_to :question_types


  
end
