//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

/*
 ***创建一个父类
 */

class Creatur
{
    var name:String
    init(name:String) {
        self.name=name
    }
    
}
/*
 ***创建一个Creature的子类
 */

class Dog : Creatur
{
    var master:String
    init(name:String,master:String) {
        self.master=master
        super.init(name: name)
    }
}
/*
 ***传建一个Bird的子类
 */

class Bird:Creatur
{
    var food:String
    init(name:String,food:String) {
        self.food=food
        super.init(name: name)
    }
}

let creature:[Creatur] =
[
Dog (name: "taidi", master: "xiaoye"),
Bird (name: "cockoo", food: "worm"),
Dog (name: "bagong", master: "Mrzhou"),
Bird (name: "dujuan", food: "sus"),
]

var dogAmount = 0

var birdAmount = 0
for item in creature {
  /*  if item is Dog
    {
        dogAmount += 1
    }
     else if item is Bird
    {
    birdAmount += 1
    
    }
 */
    if let dog = item as?Dog
    {
    
    
    }
    else if let bird = item as?Bird
    {
    print("Bird:\(bird.name),i loves \(bird.food)")
    
    }
    
}
print(dogAmount)
print(birdAmount)
















