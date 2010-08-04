require  File.dirname(__FILE__) + '/../test_helper'

class SurveyTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  fixtures :users

  test "title presence validation" do
    assert_raise( ActiveRecord::RecordInvalid ) { Survey.new.save! }
    s = Survey.new
    s.title = ""
    s.survey_category = "statistical"
    s.description = ""
    s.user_id = users(:quentin).id
    s.valid?
    assert_equal( s.errors.on(:title).to_s, "can't be blank" )
  end

test "category presence validation" do
    assert_raise( ActiveRecord::RecordInvalid ) { Survey.new.save! }
    s = Survey.new
    s.title = "test"
    s.survey_category = ""
    s.description = "test"
    s.user_id = users(:quentin).id
    s.valid?
    assert_equal( s.errors.on(:survey_category).to_s, "can't be blank" )
  end

test "user_id presence validation" do
    assert_raise( ActiveRecord::RecordInvalid ) { Survey.new.save! }
    s = Survey.new
    s.title = "test"
    s.survey_category = "paid"
    s.description = ""
    s.user_id = nil
    s.valid?
    assert_equal( s.errors.on(:user_id).to_s, "can't be blank" )
  end
  
  def test_ensure_associations_exist
    assert_equal Survey.reflect_on_all_associations(:has_many).length, 2
    all_associations = Survey.reflections
    assert_equal :has_many, all_associations[:question_surveys].macro
    assert_equal :has_many, all_associations[:questions].macro
    assert_equal :belongs_to, all_associations[:users].macro
    assert_equal :question_surveys, all_associations[:questions].options[:through]
  end
  

end
