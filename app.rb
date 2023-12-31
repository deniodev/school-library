require_relative 'person'
require_relative 'student'
require_relative 'teacher'
require_relative 'capitalize_decorator'
require_relative 'trimmer_decorator'
require_relative 'rental'
require_relative 'book'

module Infor
  @teachers = []
  @students = []
  @books = []
  @rentals = []

  def self.teachers
    @teachers
  end

  def self.students
    @students
  end

  def self.books
    @books
  end

  def self.rentals
    @rentals
  end

  def self.generate_person_id
    @students.length + @teachers.length
  end

  def self.generate_rental_id
    @rentals.length
  end
end

def new_teacher
  puts "Enter the teacher's name:"
  name = gets.chomp
  puts "Enter the teacher's specialization:"
  specialization = gets.chomp
  puts "Enter the teacher's age:"
  age = gets.chomp.to_i

  teacher = Teacher.new(age, specialization, name: name)
  teacher.instance_variable_set(:@id, Infor.generate_person_id)
  Infor.teachers << teacher

  puts "Teacher #{name} added!"
end

def new_student
  puts "Enter the student's name:"
  name = gets.chomp
  puts "Enter the student's classroom:"
  classroom = gets.chomp
  puts "Enter the student's age:"
  age = gets.chomp.to_i
  puts 'Has parent permission? [Y/N]:'
  parent_permission = gets.chomp
  parent_permission = true if %w[Y y].include?(parent_permission)
  parent_permission = false if %w[N n].include?(parent_permission)

  student = Student.new(age, classroom, name: name, parent_permission: parent_permission)
  student.instance_variable_set(:@id, Infor.generate_person_id)
  Infor.students << student

  puts "Student #{name} added!"
end

def create_person
  puts 'Enter the type of person:'
  puts '1 - student'
  puts '2 - Teacher'
  person_type = gets.chomp.to_i

  case person_type
  when 1
    new_student
  when 2
    new_teacher
  else
    puts 'Invalid! Please choose a valid option.'
  end
end

def list_people
  puts 'Listing all people...'
  puts 'Students:'
  Infor.students.each do |student|
    puts "Name: #{student.name}, Age: #{student.age}, Classrom: #{student.classroom}, " \
         "Parent_permission: #{student.parent_permission}"
  end
  puts 'Teachers:'
  Infor.teachers.each do |teacher|
    puts "Name: #{teacher.name}, Age: #{teacher.age}, " \
         "Specialization: #{teacher.specialization}"
  end
end

def new_book
  puts 'Enter book title:'
  title = gets.chomp
  puts 'Enter the book author:'
  author = gets.chomp

  book = Book.new(title, author)
  Infor.books << book

  puts "Book '#{title}' added successfully!"
end

def list_books
  Infor.books.each do |book|
    puts "Title: #{book.title}, Author: #{book.author}"
  end
end

def student_teacher
  Infor.students.each do |student|
    puts "#{student.id} - Name: #{student.name}, Age: #{student.age}"
  end
  Infor.teachers.each do |teacher|
    puts "#{teacher.id} - Name: #{teacher.name}, Age: #{teacher.age}"
  end
end

def new_rental
  puts 'Choose a person from the list below by number:'
  student_teacher
  person_index = gets.chomp.to_i

  person = if person_index < Infor.students.length
             Infor.students[person_index]
           else
             Infor.teachers[person_index - Infor.students.length]
           end

  puts person.name

  puts 'Choose a book from the list below by number:'
  Infor.books.each_with_index do |book, index|
    puts "#{index} - #{book.title}"
  end
  book_index = gets.chomp.to_i
  book = Infor.books[book_index]

  puts 'Enter the rental date (YYY-MM-DD):'
  date = gets.chomp

  rental = Rental.new(date, book, person)
  Infor.rentals << rental

  puts 'Rental added successfully!'
end

def list_rentals
  puts 'peoples list:'
  student_teacher
  puts 'Enter the person ID to list rentals:'
  person_id = gets.chomp.to_i

  rentals_available = Infor.rentals.select { |rental| rental.person.id == person_id }

  if rentals_available.empty?
    puts "No rentals available for the person with ID #{person_id}."
  else
    puts "Listing rentals for the person with ID #{person_id}:"
    rentals_available.each do |rental|
      puts "Rental Date: #{rental.date}"
      puts
    end
  end
end
