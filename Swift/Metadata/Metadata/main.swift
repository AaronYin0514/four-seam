//
//  main.swift
//  Metadata
//
//  Created by Aaron on 2021/1/5.
//

import Foundation

print("Hello, World!")

func show<T>(val: inout T) {
    print("-------------- \(type(of: val)) --------------")
    print("变量的地址:", Mems.ptr(ofVal: &val))
    print("变量的内存:", Mems.memStr(ofVal: &val))
    print("变量的大小:", Mems.size(ofVal: &val))
    print("")
}

func show<T>(ref: T) {
    print("-------------- \(type(of: ref)) --------------")
    print("对象的地址:", Mems.ptr(ofRef: ref))
    print("对象的内存:", Mems.memStr(ofRef: ref))
    print("对象的大小:", Mems.size(ofRef: ref))
    print("")
}

infix operator ~>> : MultiplicationPrecedence
func ~>> <T1, T2>(type1: T1, type2: T2.Type) -> T2 {
    return unsafeBitCast(type1, to: type2)
}

//var int64: Int64 = 10
//var int641: Int64 = 9
//show(val: &int64)
//show(val: &int641)

struct Person {
    var name: String
    var age: Int
    var sex: Bool
}

var xiaoming = Person(name: "xiaoming", age: 10, sex: true)

show(val: &xiaoming)
//0000000000000200
var personType = Person.self
var aaa = personType ~>> UnsafePointer<Int>.self
show(val: &personType)
print(String(512, radix: 2, uppercase: true))
print(aaa.pointee)

show(val: &aaa)

/**
 -------------- Person --------------
 变量的地址: 0x000000010000c210
 变量的内存: 0x676e696d6f616978 0xe800000000000000 0x000000000000000a 0x0000000000000001
 变量的大小: 32
 -------------- Person.Type --------------
 变量的地址: 0x00007ffeefbff470
 变量的内存: 0x00000001000081b0
 变量的大小: 8
 **/

print("Hello, World!")
