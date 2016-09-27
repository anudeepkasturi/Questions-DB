require 'sqlite3'
require 'singleton'

class QuestionsDB < SQLite3::Database
  include Singleton

  def initialize
   super('questions.db')
   self.type_translation = true
   self.results_as_hash = true
 end
end

class Question
  def self.find_by_id(id)
    result = QuestionsDB.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    Question.new(result)
  end

  def self.find_by_author_id(author_id)
    results = QuestionsDB.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL

    results.map { |result| Question.new(result) }
  end

  attr_accessor :body, :title, :author_id

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

end

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
end
