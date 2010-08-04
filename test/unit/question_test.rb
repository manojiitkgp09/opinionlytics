require  File.dirname(__FILE__) + '/../test_helper'

class QuestionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  fixtures :question_types

  test "question_details presence validation" do
    assert_raise( ActiveRecord::RecordInvalid ) { Question.new.save! }
    q = Question.new
    q.question_details = ""
    q.choice_details = "xxx"
    q.questiontype_id = question_types(:ftr).id
    q.valid?
    assert_equal( q.errors.on(:question_details).to_s, "can't be blank" )
  end

  test "record uniqueness validation" do
    assert_raise( ActiveRecord::RecordInvalid ) { Question.new.save! }
    q = Question.new
    q.question_details = "jshbd"
    q.choice_details = "skha"
    q.questiontype_id = question_types(:mtr).id
    q.valid?
  

    q2 = Question.new
    q2.question_details = "jshbd"
    q2.choice_details = "skha"
    q2.questiontype_id = question_types(:mtr).id
    c=q2.valid?

    puts c
    assert_equal( q2.errors.on(:question_details).to_s, "Question is Already taken" )
  end


 test "choice_details presence validation" do
    assert_raise( ActiveRecord::RecordInvalid ) { Question.new.save! }
    q = Question.new
    q.question_details = "sdsd"
    q.choice_details = ""
    q.questiontype_id = question_types(:ftr).id
    q.valid?
    assert_equal( q.errors.on(:choice_details).to_s, "can't be blank" )
  end

  def test_ensure_associations_exist
    assert_equal Question.reflect_on_all_associations(:has_many).length, 3
    assert_equal Question.reflect_on_all_associations(:belongs_to).length, 1
    all_associations = Question.reflections
    assert_equal :has_many, all_associations[:answers].macro
    assert_equal :has_many, all_associations[:surveys].macro
    assert_equal :has_many, all_associations[:question_surveys].macro
    assert_equal :belongs_to, all_associations[:question_types].macro
    assert_equal :question_surveys, all_associations[:surveys].options[:through]
  end

end
