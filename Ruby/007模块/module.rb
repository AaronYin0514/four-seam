
# 模块不能实例化

puts Math::PI

puts Math.sqrt(2)
puts Math::sqrt(2)

# 定义一个模块

module Mathematics
    
    PI = 3.141592653

    def self.sqrt(number)
        Math.sqrt(number)
    end

    # 实例方法
    def hello
        p "hello"
    end

end

puts Mathematics::PI

puts Mathematics::sqrt(2)

class Student
    # Mix In
    include Mathematics
    
    attr_accessor :name

    def initialize(name)
        @name = name
    end

end

xx = Student.new("老王")

xx.hello