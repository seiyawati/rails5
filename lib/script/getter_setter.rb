# getter, setter

class Movie
  def initialize(name)
    @name = name
  end

  # getter
  def get_name
    @name
  end

  # setter
  def set_name=(name)
    @name = name
  end
end

movie = Movie.new('ハリーポッター')
puts movie.get_name
puts movie.set_name = 'ターミネーター'

# ---------------------------------------------------------

# attr_reader, getter

class Cafe
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

cafe = Cafe.new('ドトール')
puts cafe.name
# cafe.name = 'スターバックス' undefined method `name=', NoMethodError

# ---------------------------------------------------------

# attr_reader, getter  attr_writer, setter

class Park
  attr_reader :name
  attr_writer :name

  def initialize(name)
    @name = name
  end
end

park = Park.new('宮下パーク')
puts park.name
park.name = '運動公園'
puts park.name

# ---------------------------------------------------------

# attr_accessor getter setter

class School
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

school = School.new('神田ITスクール')
puts school.name
school.name = '東進ハイスクール'
puts school.name
