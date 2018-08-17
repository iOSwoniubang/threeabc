//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

struct Animal
{
    let zooname = "beijingzoo"
    var name :String
    func say()
    {
        print("I'm \(name)")
    
    }
    


}
var animal = Animal(name:"Tiger")
animal.name = "Elephant"
animal.say()
print(animal.name)

struct Mysubscript
{
    var number:Int8
    subscript(n:Int8)->Int8
        {
    
    return number * n
    
    }
    


}
let subs = Mysubscript(number:4)
print(subs[3])


enum week
{
case mon
case week

}
