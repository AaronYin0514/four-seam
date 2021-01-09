class Student

    attr_accessor :name
    attr_accessor :gender
    attr_accessor :no

    # 构造方法
    def initialize(name,no,gender)
        @name = name # 成员变量
        @no = no
        @gender = gender
    end

end

class Student

    # 扩展方法
    def sayHello
        genderStr = @gender == 1 ? "男" : "女"
        puts "Hello 我的名字是#{@name}，我的学号是#{@no}，我的性别是#{genderStr}"
    end
    
end

xiao_hong = Student.new("小红","12123",2)

xiao_hong.sayHello

class String
    
    def self.nick_name
        p "小红"
    end

    def self.name
        "覆盖的String"
    end

end

String.nick_name

puts String.name