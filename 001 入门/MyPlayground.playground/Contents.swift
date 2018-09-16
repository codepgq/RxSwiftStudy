//: Playground - noun: a place where people can play

import Cocoa

var a = 1
let b = a + 2
print(b)
a = 4
print(b)

class Num {
    var a: Int {
        didSet {
            c = a + b
        }
    }
    var b: Int {
        didSet {
            c = a + b
        }
    }
    var c: Int = 0
    
    init(a: Int, b: Int) {
        self.a = a
        self.b = b
        self.c = a + b
    }
}

let n = Num(a: 1, b: 2)
print(n.c)

n.a = 4
print(n.c)

let numbers = [1,2,3,4,5,6,7,8,9]

print(numbers.filter { $0 % 2 == 0 })

