# Swift 4.2 更新了什么？





### 1、**Bool.toggle**

```swift
struct Layer {
    var isHidden = false
}

struct View {
    var layer = Layer()
}

var view = View()

// Before:
view.layer.isHidden = !view.layer.isHidden
view.layer.isHidden

// Now:
view.layer.isHidden.toggle()
```





### 2、对**Sequence and Collection** 新增一些方法



- **新增**`allSatisfy` 会根据**closure**中的谓词进行判断，只有全部为`true`才会返回`true`

```swift
let digits = 0...9
let areAllSmallerThanTen = digits.allSatisfy { $0 < 10 }
areAllSmallerThanTen // true

let areAllEven = digits.allSatisfy { $0 % 2 == 0 }
areAllEven    // false
```



- **新增**`last(where:)` 从后往前开始遍历，直到找到满足条件的第一个元素，返回改元素

```swift
let digits = 0...9
let lastEvenDigit = digits.last { $0 % 2 == 0 }
lastEvenDigit //8
```



- **新增** `lastIndex(where:)` 从后往前开始遍历，直到找到满足条件的第一个元素，返回其Index

```swift
let text = "Vamos a la playa"
let lastWordBreak = text.lastIndex(where: { $0 == "l" })
let lastWord = lastWordBreak.map { text[text.index(after: $0)...] }
lastWord // aya
```



- **新增**`lastIndex(of:)`从后往前遍历，直到输入的值和数组中的值相等，返回其Index

```swift
text.lastIndex(of: "l") == lastWordBreak //true
```



- **移除**`index(of:)`和`index(where:)`，分别用`firstIndex(of:)` 和 `firstIndex(where:)` 代替

```swift
let text = "Vamos a la playa"
let firstWordBreak = text.firstIndex(where: { $0 == " " })
let firstWord = firstWordBreak.map { text[..<$0] }
firstWord //Vamos
```



- **新增**`removeAll(where:)` 删除满足条件的元素

```swift
var numbers = Array(1...10)
numbers.removeAll(where: { $0 % 2 == 0 })
numbers // 1 3 5 7 9
```





### 3、新增协议 `CaseIterable`

**协议用在`enum`中，为`enum`添加了一个`allCases`属性，改属性是一个`collection`**



#### 3.1 简单使用

```swift
enum Terrain: CaseIterable {
    case water
    case forest
    case desert
    case road
}

Terrain.allCases // [water,forest,desert,road]
Terrain.allCases.count // 4
```



#### 3.2 这个属性可以用在**TableView Sections**中

```swift
enum TableSection: Int, CaseIterable {
    /// The section for the search field
    case search = 0
    /// Featured content
    case featured = 1
    /// Regular content cells
    case standard = 2
}

func numberOfSections(in tableView: UITableView) -> Int {
    return TableSection.allCases.count
}

override func tableView(_ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell
{
    let section = TableSection.allCases[indexPath.section]
    switch section {
    case .search: ...
    case .featured: ...
    case .standard: ...
    }
}
```



#### 3.3 还可以在一个`Enum`中的**case**引用另外一个`Enum`，但是必须重写`allCases`

```swift
enum Intensity: CaseIterable {
    case light
    case medium
    case hard
}

enum Workout {
    case resting
    case running(Intensity)
    case cycling(Intensity)
}

extension Workout: CaseIterable {
    static var allCases: [Workout] {
        return [.resting]
            + Intensity.allCases.map(Workout.running)
            + Intensity.allCases.map(Workout.cycling)
    }
}

Workout.allCases
/*  .resting
    .running(.light)
    .running(.medium)
    .running(.hard)
    .cycling(.light)
    .cycling(.medium)
    .cycling(.hard) */
Workout.allCases.count // 7
```



#### 3.4 为了防止在自定义的`allCases`中漏掉新增的`case`，可以在内部新增一个方法，用于提示我们需要做一些改变

```swift
extension Workout: CaseIterable {
    static var allCases: [Workout] {
        /// Dummy function whose only purpose is to produce
        /// an error when a new case is added to Workout. Never call!
        @available(*, unavailable, message: "Only for exhaustiveness checking, don't call")
        func _assertExhaustiveness(of workout: Workout, never: Never) {
            switch workout {
            case .resting,
                 .running(.light), .running(.medium), .running(.hard),
                 .cycling(.light), .cycling(.medium), .cycling(.hard):
                break
            }
        }

        return [.resting]
            + Intensity.allCases.map(Workout.running)
            + Intensity.allCases.map(Workout.cycling)
    }
}
```

这样子当我们新增了`case`，就会提示我们需要进行适配了。

**这个动作就像我们在做单元测试一样，所以当新增了`case`，务必适配`allCases`**



#### 3.5 在其他的类型中使用 `CaseInterable` 协议,

**除了普通的`enum`有着默认的实现，其他的都需要自己去重写`allCases**`

- `Bool`

```swift
extension Bool: CaseIterable {
    public static var allCases: [Bool] {
        return [false, true]
    }
}

Bool.allCases // → [false, true]
```

- `UInt8`

```swift
extension UInt8: CaseIterable {
    public static var allCases: ClosedRange<UInt8> {
        return .min ... .max
    }
}

UInt8.allCases.count // → 256
```

这里官方还给出了建议，就是如果生成的时候很消耗资源，请考虑使用`lazy`，例如:

```swift
UInt8.allCases.lazy.count
```





#### 3.6 如果allCases中有optional，那么必须定义 public typealias AllCases = [?],否则编译器会报错

```swift
extension Optional: CaseIterable where Wrapped: CaseIterable {
    public typealias AllCases = [Wrapped?]
    public static var allCases: AllCases {
        return [nil] + Wrapped.allCases.map { $0 }
    }
}
```

```swift
enum CompassDirection: CaseIterable {
    case north, south, east, west
}

CompassDirection.allCases // → [north, south, east, west]
CompassDirection.allCases.count // → 4
CompassDirection?.allCases // → [nil, north, south, east, west]
CompassDirection?.allCases.count // → 5
```





### 4、统一随机数的接口



#### 4.1数字类型

```swift
Int.random(in: 1...1000)
UInt8.random(in: .min ... .max)
Double.random(in: 0..<1)
```



#### 4.2 Bool

```swift
Bool.random()
```



#### 4.3 collection(集合)

- 随机取一个元素

```swift
let emotions = "😀😂😊😍🤪😎😩😭😡"
let randomEmotion = emotions.randomElement()! 
```



- 打乱集合 

  - `let`

    ```swift
    let numbers = 1...10
    let shuffled = numbers.shuffled()
    ```

  - `var`

    ```swift
    var mutableNumbers = Array(numbers)
    // Shuffles in place
    mutableNumbers.shuffle()	
    ```



#### 4.4 重写随机数生成器

```swift
/// A dummy random number generator that just mimics `SystemRandomNumberGenerator`.
struct MyRandomNumberGenerator: RandomNumberGenerator {
    var base = SystemRandomNumberGenerator()
    mutating func next() -> UInt64 {
        // 如果有特殊的需求，就这这里进行处理
        return base.next()
    }
}

var customRNG = MyRandomNumberGenerator()
Int.random(in: 0...100, using: &customRNG)
```



#### 4.5 为`enum`添加随机函数

```swift
enum Suit: String, CaseIterable {
    case diamonds = "♦"
    case clubs = "♣"
    case hearts = "♥"
    case spades = "♠"

    static func random<T: RandomNumberGenerator>(using generator: inout T) -> Suit {
        // Using CaseIterable for the implementation
        return allCases.randomElement(using: &generator)!

    }

    static func random() -> Suit {
        // 如果不需要系统的随机数生成，就把这个类型替换
        var rng = SystemRandomNumberGenerator()
        return Suit.random(using: &rng)
    }
}

let randomSuit = Suit.random()
randomSuit.rawValue 
```





### 5、重新设计了Hashable

**减少hash值碰撞**

栗子：

```swift
struct Point {
    var x: Int { didSet { recomputeDistance() } }
    var y: Int { didSet { recomputeDistance() } }

    /// Cached. Should be ignored by Equatable and Hashable.
    private(set) var distanceFromOrigin: Double

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.distanceFromOrigin = Point.distanceFromOrigin(x: x, y: y)
    }

    private mutating func recomputeDistance() {
        distanceFromOrigin = Point.distanceFromOrigin(x: x, y: y)
    }

    private static func distanceFromOrigin(x: Int, y: Int) -> Double {
        return Double(x * x + y * y).squareRoot()
    }
}

extension Point: Equatable {
    static func ==(lhs: Point, rhs: Point) -> Bool {
        // Ignore distanceFromOrigin for determining equality
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension Point: Hashable {
    func hash(into hasher: inout Hasher) {
        // Ignore distanceFromOrigin for hashing
        hasher.combine(x)
        hasher.combine(y)
    }
}

let p1 = Point(x: 3, y: 4)
p1.hashValue
let p2 = Point(x: 4, y: 3)
p2.hashValue
assert(p1.hashValue != p2.hashValue)
```

如果类/结构体中的数据类型都是一种，比如`Int`，在采用`return x ^ y`这种算法，就很容易发生碰撞，所以我们在重写`hash`的时候一定要注意这个东西，要在性能和碰撞之间做平衡。



### 6、动态映射的修改

```swift
func isEncodable(_ value: Any) -> Bool {
    return value is Encodable
}

// This would return false in Swift 4.1
let encodableArray = [1, 2, 3]
isEncodable(encodableArray)

// Verify that the dynamic check doesn't succeed when the conditional conformance criteria aren't met.
struct NonEncodable {}
let nonEncodableArray = [NonEncodable(), NonEncodable()]
isEncodable(nonEncodableArray)//false
assert(isEncodable(nonEncodableArray) == false)
```



#### 7、扩展中的合成一致性

```swift
enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}

// No code necessary
extension Either: Equatable where Left: Equatable, Right: Equatable {}
extension Either: Hashable where Left: Hashable, Right: Hashable {}

Either<Int, String>.left(42) == Either<Int, String>.left(42) //true
```





#### 8、Range的修改

**官方说道：`CountableRange`和`CountableClosedRange`还存在，但是不应该在之后的代码中使用到他们了，这个是为了兼容之前的代码**

```swift
let integerRange: Range = 0..<5
// integer是一个collection，所以可以调用map方法
let integerStrings = integerRange.map { String($0) }
integerStrings

let floatRange: Range = 0.0..<5.0
// 以为float不是一个collection，所以不能调用map方法
//floatRange.map { String($0) } // error!
```



#### 9、新增@dynamicMemberLookup

**允许我们运行时，动态查找属性**，**可以用来修饰**`class/struct/protocol/enum`

**使用`@dynamicMemberLookup`需要重写如下代码：**

```swift
subscript(dynamicMember input: String) -> XX {
    get {
            guard let value = getenv(name) else { return nil }
            return xx
        }
    nonmutating set {
        if let value = newValue {
            setenv(name, value, /*overwrite:*/ 1)
        } else {
            unsetenv(name)
        }
    }
}
```



```swift
@dynamicMemberLookup
struct Uppercaser {
    subscript(dynamicMember input: String) -> String {
        return input.uppercased()
    }
}

Uppercaser().hello // → "HELLO"
// You can type anything, as long as Swift accepts it as an identifier.
Uppercaser().käsesoße // → "KÄSESOSSE"
```





#### 10、`guard let self = self`

喜大奔普终于不用写

```swift
guard let `self` = self ...
```





### 11、if let self = self { … }  

也不用这样子写啦

```swift
if let weakself = self { … }
```





#### 12、支持`#warring`和`#error`啦

- #error 

  ```swift
  #if MYLIB_VERSION < 3 && os(macOS)
  #error("MyLib versions < 3 are not supported on macOS")
  #endif
  ```



- #warring

  ```swift
  func doSomethingImportant() {
      #warning("TODO: missing implementation")
  }
  doSomethingImportant()
  ```



#### 13、**#if compiler** **version directive**

```swift
#if compiler(>=4.2)
print("Using the Swift 4.2 compiler or greater in any compatibility mode")
print("swift编译器大于等于4.2") //菜鸡翻译，如果不准，烦请告知
#endif

#if swift(>=4.2)
print("Using the Swift 4.2 compiler or greater in Swift 4.2 or greater compatibility mode")
print("使用swift4.2编译器编译swift大于/等于4.2的版本") //菜鸡翻译，如果不准，烦请告知
#endif

#if compiler(>=5.0)
print("Using the Swift 5.0 compiler or greater in any compatibility mode")
print("swift编译器大于等于5.0") //菜鸡翻译，如果不准，烦请告知
#endif
```





#### 14、`MemoryLayout`中新增`offset(of:)`方法

```swift
struct Point {
    var x: Float
    var y: Float
    var z: Float
}

MemoryLayout<Point>.offset(of: \Point.x) // 0
MemoryLayout<Point>.offset(of: \Point.y) // 4
MemoryLayout<Point>.offset(of: \Point.z) // 8
```
官方解释：

许多图形和数学库接受任意输入格式的输入数据，用户在设置输入缓冲区时必须向API描述。例如，OpenGL允许您使用一系列`glVertexAttribPointer`API 调用来描述顶点缓冲区的布局。在C中，您可以使用标准`offsetof`宏来获取结构中字段的偏移量，允许您使用编译器对类型布局的了解来填充这些函数调用：

```
//我们的一个顶点条目的布局
结构 MyVertex {
   float position [ 4 ];
  漂浮 正常 [ 4 ];
  uint16_t texcoord [ 2 ];
};

枚举 MyVertexAttribute {Position，Normal，TexCoord};

glVertexAttribPointer（Position，4，GL_FLOAT，GL_FALSE，
                       sizeof（MyVertex），（void *）offsetof（MyVertex，position））;
glVertexAttribPointer（Normal，4，GL_FLOAT，GL_FALSE，
                       sizeof（MyVertex），（void *）offsetof（MyVertex，normal））;
glVertexAttribPointer（TexCoord，2，GL_UNSIGNED_BYTE，GL_TRUE，
                       sizeof（MyVertex），（void *）offsetof（MyVertex，texcoord））;
```

目前`offsetof`在Swift中没有相同的功能，因此这些API的用户必须在C中编写代码的这些部分，或者在头脑中执行Swift内存布局，如果他们更改了数据布局或Swift，则容易出错。编译器实现更改其布局算法（它保留权利）。



#### 15、新增两个修饰符`@inlinable` 和 `@usableFromInline`



- **`@inlinable` :** 开发者可以将一些公共功能注释为`@inlinable`。这给编译器提供了优化跨模块边界的泛型代码的选项

```swift
@inlinable public func allEqual<T>(_ seq: T) -> Bool
    where T : Sequence, T.Element : Equatable {
  var iter = seq.makeIterator()
  guard let first = iter.next() else { return true }

  func rec(_ iter: inout T.Iterator) -> Bool {
    guard let next = iter.next() else { return true }
    return next == first && rec(&iter)
  }

  return rec(&iter)
}
```



- **`usableFromInline`:**  使用`@usableFromInline`在你的“ABI-public”库中进行某些内部声明，允许它们在可链接函数中使用。

  ```swift
  public class C {
    @usableFromInline internal class D {
      @usableFromInline internal func f() {}
      
      @inlinable internal func g() {}
    }
  }
  ```


#### 16、withUnsafePointer(to:*:) 和 withUnsafeBytes(of:*:)

`withUnsafePointer`和`withUnsafeBytes`通过指针提供对变量和属性的内存表示的临时范围访问。它们当前只接受`inout`参数，这使得处理不可变值的内存表示比它应该做的更尴尬和更低效，需要复制：

```swift
let x = 1 + 6
var x2 = x
let value = withUnsafeBytes(of: &x2) {
    ptr in
    return (ptr[0] + ptr[1])
} 
value // 7
```



其内部实现如下：

```swift
public func withUnsafePointer<T, Result>(
  to value: /*borrowed*/ T,
  _ body: (UnsafePointer<T>) throws -> Result
) rethrows -> Result

public func withUnsafeBytes<T, Result>(
  of value: /*borrowed*/ T,
  _ body: (UnsafeRawBufferPointer) throws -> Result
) re
```

