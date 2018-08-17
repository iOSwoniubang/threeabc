//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

/*
 ***枚举***
 */
enum UserLevel
{
    case 总经理
    case 区域经理
    case 主管
    case 大区经理
}
let userlevel = UserLevel.总经理

print(UserLevel.区域经理)
switch userlevel
{
case UserLevel.区域经理:
    print("老子是总经理")
case UserLevel.大区经理:
    print("我是大区经理")
case UserLevel.总经理:
    print("我是总计里")
    
default:
    print("请核对好自己身份")
}
enum Gender:Int8
{
case xiaoye = 1
case xiaoin
case liubang
    func description() {
        switch self {
        case Gender.xiaoye:
            print("hi girl")
        case Gender.xiaoin:
            print("hi boy")
        case Gender.liubang:
            print("beautiful girl")
        }
    }
}

let  xiaolin = Gender.xiaoin
xiaolin.description()



