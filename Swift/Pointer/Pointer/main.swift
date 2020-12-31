//
//  main.swift
//  Pointer
//
//  Created by Aaron on 2020/12/31.
//

import Foundation

struct Student {
    var name: String
    var age: Int
    var sex: Bool
}

class Person {
    var name: String
    var age: Int
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

// MARK: - Memory Layout

print(MemoryLayout<Person>.stride)
print(MemoryLayout<Person>.size)
print(MemoryLayout<Person>.alignment)

print(MemoryLayout<Student>.stride)
print(MemoryLayout<Student>.size)
print(MemoryLayout<Student>.alignment)

// MARK: - 指针

/**
 Swift中也有专门的指针类型，这些都被定性为“Unsafe”（不安全的），常见的有以下4种类型
 * UnsafePointer<Pointee> 类似于 const Pointee *
 * UnsafeMutablePointer<Pointee> 类似于 Pointee *
 * UnsafeRawPointer 类似于 const void *
 * UnsafeMutableRawPointer 类似于 void *
 */

var age = 10

func test1(ptr: UnsafeMutablePointer<Int>) {
    ptr.pointee = 50
}

func test2(ptr: UnsafePointer<Int>) {
    print(ptr.pointee)
}

func test3(ptr: UnsafeMutableRawPointer) {
    ptr.storeBytes(of: 100, as: Int.self)
}

func test4(ptr: UnsafeRawPointer) {
    print(ptr.load(as: Int.self))
}

print(age)

test1(ptr: &age)
test2(ptr: &age)

test3(ptr: &age)
test4(ptr: &age)

// MARK: - 获得指向某个变量的指针

let ptr1 = withUnsafePointer(to: &age) { $0 }
let ptr2 = withUnsafeMutablePointer(to: &age) { $0 }

ptr2.pointee = 150
print(ptr1.pointee)

let ptr3 = withUnsafePointer(to: &age) { UnsafeRawPointer($0) }
let ptr4 = withUnsafeMutablePointer(to: &age) { UnsafeMutableRawPointer($0) }

ptr4.storeBytes(of: 200, as: Int.self)
print(ptr3.load(as: Int.self))

// MARK: - 获得指向堆空间实例的

var person = Person(name: "xiao_ming", age: 10)
let personPtr = withUnsafePointer(to: &person) {
    UnsafeRawPointer($0)
}
let personHeapPtr = UnsafeRawPointer(bitPattern: personPtr.load(as: UInt.self))
print(personHeapPtr!)

print("Hello, World!")

// MARK: - 创建指针

/// 1 地址创建

let ptr5 = UnsafeRawPointer(bitPattern: 0x100001234)

/// 2 malloc
let ptr6 = malloc(16)
// 存
ptr6?.storeBytes(of: 10, as: Int.self)
ptr6?.storeBytes(of: 11, toByteOffset: 8, as: Int.self)
// 取
print(ptr6?.load(as: Int.self))
print(ptr6?.load(fromByteOffset: 8, as: Int.self))
// 销毁
free(ptr6)

/// 3 UnsafeMutableRawPointer

var ptr7 = UnsafeMutableRawPointer.allocate(byteCount: 16, alignment: 1)
ptr7.storeBytes(of: 101, as: Int.self)
ptr7.advanced(by: 8).storeBytes(of: 102, as: Int.self)
print(ptr7.load(as: Int.self))
print(ptr7.advanced(by: 8).load(as: Int.self))
ptr7.deallocate()

/// 4 UnsafeMutablePointer<>
var ptr8 = UnsafeMutablePointer<Int>.allocate(capacity: 3)

//ptr8.initialize(repeating: 12, count: 3)

ptr8.initialize(to: 11)
ptr8.successor().initialize(to: 12)
ptr8.successor().successor().initialize(to: 13)

print(ptr8.pointee)
print((ptr8 + 1).pointee)
print((ptr8 + 2).pointee)

print(ptr8[0])
print(ptr8[1])
print(ptr8[2])

ptr8[2] = 189
print(ptr8[2])

ptr8.deinitialize(count: 3)
ptr8.deallocate()

/// 5 创建Person
var ptr9 = UnsafeMutablePointer<Person>.allocate(capacity: 3)
ptr9.initialize(to: Person(name: "Jack", age: 18))
(ptr9 + 1).initialize(to: Person(name: "Rose", age: 17))
(ptr9 + 2).initialize(to: Person(name: "Kate", age: 19))

ptr9.deinitialize(count: 3)
ptr9.deallocate()

/// 6 UnsafeBufferPointer
var arr = [1, 2, 3, 400]
let ptr__9 = UnsafeBufferPointer(start: &arr, count: 4)

ptr__9.forEach {
    print($0)
}

// MARK: - 指针类型互相转换

var ptr10 = UnsafeMutableRawPointer.allocate(byteCount: 16, alignment: 1)

ptr10.assumingMemoryBound(to: Int.self).pointee = 11
(ptr10 + 8).assumingMemoryBound(to: Double.self).pointee = 22.0

print(unsafeBitCast(ptr10, to: UnsafePointer<Int>.self).pointee)
print(unsafeBitCast(ptr10 + 8, to: UnsafePointer<Double>.self).pointee)

ptr10.deallocate()

// 将内存临时重新绑定到其他类型
let ptr11 = UnsafePointer(&age)
ptr11.withMemoryRebound(to: UInt.self, capacity: 1) {
    print($0.pointee)
}

// 将内存永久重新绑定到其他类型
let ptr12 = UnsafeRawPointer(&age)
let ptr13 = ptr12.bindMemory(to: UInt.self, capacity: 1)
print(ptr13.pointee)

// MARK: - 通过指针为属性赋值

var zhouMeng = Student(name: "zhou_meng", age: 18, sex: false)
//let pStructHeadP = withUnsafeMutablePointer(to: &zhouMeng, {
//    return UnsafeMutableRawPointer($0).bindMemory(to: Int8.self, capacity: MemoryLayout<Person>.stride)
//})
// 将 headPointer 转化为 rawPointer, 方便移位操作
//let pStructHeadRawP = UnsafeMutableRawPointer(pStructHeadP)
//let pStructHeadRawP = withUnsafeMutablePointer(to: &zhouMeng, {
//    return UnsafeMutableRawPointer($0)
//})
let pStructHeadRawP = UnsafeMutableRawPointer(&zhouMeng)

// 每个属性在内存中的位置
let namePosition = 0
let agePosition = namePosition + MemoryLayout<String>.stride
let isBoyPosition = agePosition + MemoryLayout<Int>.stride

// 将内存临时重新绑定到其他类型进行访问.
//let namePtr = pStructHeadRawP.advanced(by: 0).assumingMemoryBound(to: String.self)
//let agePtr = pStructHeadRawP.advanced(by: agePosition).assumingMemoryBound(to: Int.self)
//let isBoyPtr = pStructHeadRawP.advanced(by: isBoyPosition).assumingMemoryBound(to: Bool.self)

let namePtr = pStructHeadRawP.assumingMemoryBound(to: String.self)
let agePtr = (pStructHeadRawP + agePosition).assumingMemoryBound(to: Int.self)
let isBoyPtr = (pStructHeadRawP + isBoyPosition).assumingMemoryBound(to: Bool.self)

// 设置属性值
namePtr.pointee = "lily"
agePtr.pointee = 20
isBoyPtr.pointee = true

print(zhouMeng.name)
print(zhouMeng.age)
print(zhouMeng.sex)


/// Class

var zhouMengClass = Person(name: "ZhouMeng", age: 18)
// 获得头部指针
let pClassHeadRawP = Unmanaged.passUnretained(zhouMengClass as AnyObject).toOpaque()

// 获取每个属性在内存中的位置
let namePosition2 = 16
let agePosition2 = namePosition2 + MemoryLayout<String>.stride

// 将内存临时重新绑定到其他类型进行访问.
let namePtr2 = pClassHeadRawP.advanced(by: namePosition2).assumingMemoryBound(to: String.self)
let agePtr2 = pClassHeadRawP.advanced(by: agePosition2).assumingMemoryBound(to: Int.self)

// 设置属性值
namePtr2.pointee = "maris"
agePtr2.pointee = 38

print(zhouMengClass.name)
print(zhouMengClass.age)
