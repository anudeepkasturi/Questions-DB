require_relative 'questions'

class QuestionFollow
  def self.followers_for_question_id(question_id)
    results = QuestionsDB.instance.execute(<<-SQL, question_id)
      SELECT
        user_id
      FROM
        questions_follows
      WHERE
        question_id = ?
    SQL

    results.map { |result| User.find_by_id(result) }
  end

  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDB.instance.execute(<<-SQL, user_id)
      SELECT
        question_id
      FROM
        questions_follows
      WHERE
        user_id = ?
    SQL

    results.map { |result| Question.find_by_id(result) }
  end

  def most_followed_questions(n)
    results = QuestionsDB.instance.execute(<<-SQL, n)
      SELECT
        question_id
      FROM
        questions_follows
      GROUP BY
        question_id
      ORDER BY
        COUNT(user_id) DESC
      LIMIT ?
    SQL

    results.map { |result| Question.find_by_id(result) }
  end
end
