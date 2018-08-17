//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


class Car
{
    var name:String
    var speed : Int8
    init() {
        self.name = ""
        self.speed = 0
    }
    func driver()
    {
        print("Driving \(name) at speed \(speed)")
    
    }

}
let car = Car()
car.name="BMW"
car.speed=120
car.driver()


class Hero {
    var damage : Int8 = 10
    var level : Int8
        {
    get
    {
        return self.damage/10
        
        }
    set(newLevel)
    {
        self.damage = newLevel * 10
        }
    }
}
let hero = Hero ()
print(hero.level)
print(hero.damage)
hero.level = 10
print(hero.damage)
                  /********willset和didSet的方法使用**********/

class HERO
{
    var damage:Int8 = 10
    var level:Int8 = 1
        {
    willSet
    {
        print("即将设置新值1")
        }
        didSet
        {
            if level > oldValue {
                print("你的英雄升级了")
            }
            else
            {
            print("挑战失败 未能升级")
            }
        
        }
        
    }
}

let heroo = HERO()
heroo.level = 2
heroo.level = 2

class Animal
{
    func say(){
    
    print(" I'm a animal")
    }
 

}
class Dog:Animal
{
    var name : String
    init(name:String) {
        self.name = name
    }
    override func say() {
        print("你是狗，你的名字是 \(name)")
    }

}
var dog = Dog(name:"taidi")
dog.say()





























		