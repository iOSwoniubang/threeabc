//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
for step in 0..<3 {
    print("step in \(step)")
}
for index in 0...3
{
    print("index in \(index)")
}
let 学生成绩 = ["l学生刘":88,"xiaoye":99,"xiaolin":60];
for (student,score) in 学生成绩 {
    print(student+"'score学生的发到的防守打法的 is \(score) " )
}

print("\u{600}")

var index33 = 0
repeat
{
    index33 += 1
    print("again")
}
    while index33<3
let IDCard = "123456789987654321"
let count = IDCard.lengthOfBytes(using: String.Encoding.utf8)

if (count != 18&&count != 15) {
    print("错误的手机号码")
}

let time = 10
switch time {
case 1...9:
    print("busy")
case 10,12,13:
    print("give my time i can fly")
default:
    print("NObusy")
}


let  time33 = 6
var message = "it's now"
switch time33 {
case 2,3,5,6,12,18:
    message += "\(time33)o'clock"
    fallthrough
default:
    message += "."
    print(message)
}

let stringArray = Array<String>()
let floatArray = [Float]()
var intArraay = [1,2,3,4,5,6,7]
print(intArraay.sort())
print(intArraay[4])
intArraay.contains(6)
intArraay.count
intArraay.isEmpty


intArraay += [6]
intArraay.append(9)

intArraay.insert(88, at: 6)


print(intArraay.sorted())
intArraay.sort()

for num in intArraay.sorted() {
    print(num)
}
let range = 2..<intArraay.count
for (index,value) in zip(range, intArraay[range]) {
    print("\(index):\(value)")
}










