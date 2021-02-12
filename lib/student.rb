class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
      SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      SQL
    DB[:conn].execute(sql).each do |row|
      if row[1] == name
        return self.new_from_db(row)
      end
    end
  end

  def self.all_students_in_grade_9
    return_array = []
    sql = <<-SQL
      SELECT *
      FROM students
      SQL
    DB[:conn].execute(sql).each do |row|
      if row[2].to_i == 9
        return_array << self.new_from_db(row)
      end
    end
    return_array
  end

  def self.students_below_12th_grade
    return_array = []
    sql = <<-SQL
      SELECT *
      FROM students
      SQL
    DB[:conn].execute(sql).each do |row|
      if row[2].to_i < 12
        return_array << self.new_from_db(row)
      end
    end
    return_array
  end

  def self.first_X_students_in_grade_10(number)
    return_array = []
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = 10
      LIMIT #{number}
      SQL
    DB[:conn].execute(sql).each do |row|
        return_array << self.new_from_db(row)
    end
    return_array
  end

  def self.first_student_in_grade_10
    return_array = []
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = 10
      LIMIT 1
      SQL
    return self.new_from_db(DB[:conn].execute(sql)[0])
  end

  def self.all_students_in_grade_X(grade)
    return_array = []
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = #{grade}
      SQL
    DB[:conn].execute(sql).each do |row|
      return_array << self.new_from_db(row)
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
