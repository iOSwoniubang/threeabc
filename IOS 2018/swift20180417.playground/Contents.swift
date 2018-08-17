//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
var dallingCode = Dictionary<String,String>()


dallingCode=["010":"北京","021":"shanghai","0592":"xiamen"]
dallingCode["003"]="liubang"
print(dallingCode)
print(dallingCode["021"] ?? String())

dallingCode.updateValue("liubang003", forKey: "003")
print(dallingCode["003"] ?? String())

func goodstu(age:UInt8,name:String)->NSString
{
print(name+"'age is \(age)")
return "333"
}
goodstu(age: 15, name: "liubang")
func sum(number1:Int8,number2:Int8)->Int8
{
return number1 + number2


}
let result = sum(number1: 1, number2: 15)
print(result)
func getDistance(eneryPo:CGPoint,turrentPo:CGPoint=CGPoint(x:100,y:100))->CGFloat
{
    let xd = turrentPo.x - eneryPo.x
    let yd = turrentPo.y - eneryPo.y
    return sqrt(xd*xd + yd*yd)
}
let cgpoin = CGPoint(x:50,y:50)
let cg2 = CGPoint(x:80,y:90)

getDistance(eneryPo: cgpoin)
let dis = getDistance(eneryPo: cgpoin,turrentPo: cg2)
print(dis)
func getAvg(numbers:Double...)->Double
{
    if numbers.count == 0 {
        return 0.0
    }
    var total:Double = 0
    for numbersome in numbers {
        total += numbersome
    }
    return total/Double(numbers.count)
    
    
    
}

getAvg(numbers: 1,2,3,4,5,6,5,5,5,5,5,5,5)
