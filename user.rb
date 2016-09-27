require_relative 'questions'

class User
  def self.find_by_id(id)
    result = QuestionsDB.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    User.new(result)
  end

  def self.find_by_name(fname, lname)
    result = QuestionsDB.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ?,
        lname = ?
    SQL

    User.new(result)
  end

  attr_accessor :fname, :lname

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDB.instance.execute(<<-SQL, @fname, @lname)
      INSERT INTO
        users (fname, lname)
      VALUES
        (?, ?)
    SQL
    @id = QuestionsDB.instance.last_insert_row_id
  end

  def update
    raise "#{self} already in database" unless @id
    QuestionsDB.instance.execute(<<-SQL, @fname, @lname, @id)
      UPDATE
        users
      SET
        fname = ?, lname = ?
      WHERE
        id = ?
    SQL
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    QuestionsDB.instance.execute(<<-SQL, @id)
      SELECT
        CAST( COUNT( DISTINCT( questions_likes.question_id )) AS FLOAT)
        / COUNT( DISTINCT( questions_by_user.id ))
      FROM (
        SELECT
          *
        FROM
          questions
        WHERE
          author_id = 1) AS questions_by_user
      LEFT OUTER JOIN
        questions_likes
      ON questions_likes.question_id = questions_by_user.id
    SQL
  end
end
