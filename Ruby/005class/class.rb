class Student

    # 类常量
    Version = "1.0.0"

    # 读写成员变量
    attr_accessor :no
    # 只读成员变量
    attr_reader :gender
    # 读写成员变量
    attr_writer :my_class

    # 构造方法
    def initialize(name,no,gender,my_class)
        @name = name # 成员变量
        @no = no
        @gender = gender
        @my_class = my_class
    end

    # 成员方法
    def sayHello
        genderStr = @gender == 1 ? "男" : "女"
        puts "Hello 我的名字是#{@name}，我的班级是#{@my_class}，我的学号是#{@no}，我的性别是#{genderStr}"
    end

    # Setter方法
    def name=(name)
        @name = name
    end

    # Getter方法
    def name
        return @name
    end

    # 类方法
    def self.nick_name
        return "学生类"
    end

end

xiao_ming = Student.new "小明","001",1,"三年一班"

xiao_ming.sayHello

xiao_ming.name = "小鸣"
puts xiao_ming.name

xiao_ming.no = "002"
puts xiao_ming.no

# xiao_ming.gender = 2 # 只读
puts xiao_ming.gender

xiao_ming.my_class = "四年一班"
# puts xiao_ming.my_class # 只写
xiao_ming.sayHello

puts Student::Version

puts Student.nick_name

# 类的继承
class UniversityStudent < Student

    # 扩展方法
    def say_english
        p "my english is very good"
    end

    # 重写方法
    def sayHello
        puts "UniversityStudent say hello"
    end

end

liming = UniversityStudent.new("李明","123",1,"大一三班")

liming.say_english

liming.sayHello

