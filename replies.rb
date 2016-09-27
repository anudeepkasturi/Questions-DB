require_relative 'questions'

class Reply
  def self.find_by_id(id)
    result = QuestionsDB.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL

    Reply.new(result)
  end

  attr_accessor :question_id, :reply_id, :user_id, :body

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @reply_id = options['reply_id']
    @user_id = options['user_id']
    @body = options['body']
  end

end
