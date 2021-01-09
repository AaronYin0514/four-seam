# 逻辑运算符

#   1 与运算 &&
#   2 或运算 ||

a = true
b = false

puts a && b
puts a || b

# 条件运算符

# 范围运算符

c = "Hello ruby"

puts c[0..4]

puts c[0...4]

# 自定义运算符

class Vector

    attr_accessor :x, :y

    def initialize(x, y)
        @x = x
        @y = y
    end

    def +(the_vector)
        Vector.new(@x+the_vector.x, @y+the_vector.y)
    end
end

d = Vector.new(2, 3)
e = Vector.new(1, 2)

fx = (d+(e)).x
fy = (d+(e)).y

gx = (d+e).x
gy = (d+e).y

puts fx
puts fy
puts gx
puts gy
