//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
var hello = "hello, Swift!"
hello.substring(from: hello.index(hello.startIndex, offsetBy: 7))
hello.substring(to: hello.index(hello.startIndex, offsetBy: 3))
hello.replacingOccurrences(of: "hello", with: "HI")
print(hello)
hello.remove(at: hello.index(hello.startIndex, offsetBy: 5))
print(hello)

//遍历
var num = 0
let phonenum = "17788557257"

for temp in phonenum.characters {
    if temp == "7" {
        num += 1
    }
}
print(num)

for i in phonenum.characters {
    if i == "8" {
        num += 1
    }
}
print(num)


let error404 = (404, "not found")
print(error404.1)

let xiaoming = (age:23, name:"xiaoxiao")
print(xiaoming.age)


		