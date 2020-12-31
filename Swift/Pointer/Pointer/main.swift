//
//  main.swift
//  Pointer
//
//  Created by Aaron on 2020/12/31.
//

import Foundation

print("Hello, World!")

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

// 获得指向某个变量的指针

let ptr1 = withUnsafePointer(to: &age) { $0 }
let ptr2 = withUnsafeMutablePointer(to: &age) { $0 }

ptr2.pointee = 150
print(ptr1.pointee)

let ptr3 = withUnsafePointer(to: &age) { UnsafeRawPointer($0) }
let ptr4 = withUnsafeMutablePointer(to: &age) { UnsafeMutableRawPointer($0) }

ptr4.storeBytes(of: 200, as: Int.self)
print(ptr3.load(as: Int.self))

class Person {
    var name: String
    var age: Int
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

// 获得指向堆空间实例的

var person = Person(name: "xiao_ming", age: 10)
let personPtr = withUnsafePointer(to: &person) {
    UnsafeRawPointer($0)
}
let personHeapPtr = UnsafeRawPointer(bitPattern: personPtr.load(as: UInt.self))
print(personHeapPtr!)

print("Hello, World!")

// 创建指针UnsafePointer

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

// 指针类型互相转换
var ptr10 = UnsafeMutableRawPointer.allocate(byteCount: 16, alignment: 1)

ptr10.assumingMemoryBound(to: Int.self).pointee = 11
(ptr10 + 8).assumingMemoryBound(to: Double.self).pointee = 22.0

print(unsafeBitCast(ptr10, to: UnsafePointer<Int>.self).pointee)
print(unsafeBitCast(ptr10 + 8, to: UnsafePointer<Double>.self).pointee)

ptr10.deallocate()
