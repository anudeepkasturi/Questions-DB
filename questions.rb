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

  attr_accessor :body, :title, :author_id

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

end
