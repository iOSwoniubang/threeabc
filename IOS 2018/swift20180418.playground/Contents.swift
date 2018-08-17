//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
let IDcard = "555511112222333344"
let count = IDcard.lengthOfBytes(using: String.Encoding.utf8)
func getSmall (number1:Int8,number2:Int8) ->Int8
{
    return((number1<number2) ? number1 : number2)
}
func getBigger (number3:Int8,number4:Int8)->Int8
{
    return((number3>number4) ? number3 : number4)
}
getSmall(number1: 3, number2: 4)
getBigger(number3: 5, number4: 6)

func printMathResult(mathFunction:(Int8,Int8)->Int8,num1:Int8,num2:Int8)
{
    print("The Resiukt \(mathFunction(num1,num2))")

}
printMathResult(mathFunction: getSmall, num1: 1, num2: 2)
printMathResult(mathFunction: getBigger, num1: 3, num2: 4)

func PrintHello()
{

print("hello world")
}
let anotherFunc = PrintHello
anotherFunc()
func swappp(prevNumber:inout Double,nextNumbb:inout Double)
{
    let tempnum  = prevNumber
    prevNumber = nextNumbb
    
    nextNumbb = tempnum
}
var prev:Double = 2
var nextnumm:Double = 3
swappp(prevNumber: &prev, nextNumbb: &nextnumm)

print(prev)
print(nextnumm)
func chooseNum(biggerNumber:Bool,num7:Int8,num8:Int8){

    func numbigger()
    {
        print((num7 > num8) ? num7 : num8 )
    }
    func numsmall()
    {
    print((num7 > num8) ? num8 : num7 )
    }

    biggerNumber ? numbigger() : numsmall()

}

chooseNum(biggerNumber: false, num7: 8, num8: 9)

func resusic(n:Int8)->Int8
{
    if n <= 1 {
        return 1
    }
    else
    {
    return resusic(n: n-1)+resusic(n: n-4)
    
    }

}

resusic(n: 5)


print(abs(-3))

print(min(5, 6, 7, 8, 4))


for i in (1...10).filter({$0 % 3 == 0}) {
    print(i)
}

for i in (1...4).map({$0 * 3})
{
print(i)
}
let result = (1...7).reduce(0,+)

print(result)

let result333 = (1...4).reduce(1, *)
print(result333)

for i in (1...4).map({$0 * 3}) {
    print(i)
}






