DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS questions_follows;

CREATE TABLE questions_follows (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  reply_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id)
  FOREIGN KEY (reply_id) REFERENCES replies(id)
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS questions_likes;

CREATE TABLE questions_likes (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Brian', 'Lee'),
  ('Ish', 'Kasturi');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Life', 'What is the meaning of life?', 1),
  ('Assessment', 'Does my life depend on passing the assessment?', 2);

INSERT INTO
  questions_follows (user_id, question_id)
VALUES
  (1, 1),
  (2, 2);

INSERT INTO
  replies (question_id, user_id, body)
VALUES
  (1, 2, '42');

INSERT INTO
  replies (question_id, reply_id, user_id, body)
VALUES
  (1, 1, 1, 'Thanks!');


INSERT INTO
  questions_likes (user_id, question_id)
VALUES
  (1, 2),
  (2, 1);
