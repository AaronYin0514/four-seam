
# 方法
def test
    puts "Hello World!"
end

# 带参数
def sayHi(name,no)
    puts "我叫#{name},学号#{no},Hello"
end

# 默认参数

def add(a = 3, b = 3)
    return a + b
end

test

sayHi("Aaron", "8888")

res = add 7

puts res