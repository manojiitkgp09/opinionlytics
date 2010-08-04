class AnswerQuestion < ActiveRecord::Base

  has_many :questions
  belongs_to :answers
  validates_uniqueness_of :answer_id, :scope => [:question_id, :answer_text] 

end
