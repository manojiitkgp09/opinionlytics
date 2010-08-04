class Survey < ActiveRecord::Base
  
  belongs_to :users 
  
  has_many :question_surveys, :dependent => :destroy
     
  validates_presence_of :title
  validates_presence_of :user_id
  validates_presence_of :survey_category

  def self.find_user_surveys(user_id)
    Survey.find(:all, :conditions => {:user_id => user_id, :status => true} )
  end
  
end
