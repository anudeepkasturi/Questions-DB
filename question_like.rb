require_relative 'questions'

class QuestionLike
  def self.likers_for_question_id(question_id)
    results = QuestionsDB.instance.execute(<<-SQL, question_id)
      SELECT
        user_id
      FROM
        questions_likes
      WHERE
        question_id = ?
    SQL

    results.map { |result| User.find_by_id(result) }
  end

  def self.num_likes_for_question_id(question_id)
    QuestionsDB.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*)
      FROM
        questions_likes
      WHERE
        question_id = ?
    SQL
  end

  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDB.instance.execute(<<-SQL, user_id)
      SELECT
        question_id
      FROM
        questions_likes
      WHERE
        user_id = ?
    SQL

    results.map { |result| Question.find_by_id(result) }
  end
end
