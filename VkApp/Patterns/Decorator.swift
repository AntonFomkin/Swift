import Foundation

protocol Coffee: class {
    var cost: Double { get }
}

final class SimpleCoffee: Coffee {
    var cost: Double {
        return 20.0
    }
}

protocol CoffeeDecorator: Coffee {
    var obj: Coffee { get }
    
    init (obj:Coffee)
}


final class Milk: CoffeeDecorator {
    let obj: Coffee
    var cost: Double {
        return obj.cost + 10
    }
    
    required init(obj: Coffee) {
        self.obj = obj
    }
}

final class Whip: CoffeeDecorator {
    let obj: Coffee
    var cost: Double {
        return obj.cost + 5
    }
    
    required init(obj: Coffee) {
        self.obj = obj
    }
}

final class Sugar: CoffeeDecorator {
    let obj: Coffee
    var cost: Double {
        return obj.cost + 7
    }
    
    required init(obj: Coffee) {
        self.obj = obj
    }
}

let cofeWater = SimpleCoffee()
print(cofeWater.cost)

let cofeWaterAndMilk = Milk(obj: cofeWater)
print(cofeWaterAndMilk.cost)

let cofeWaterAndSugar = Sugar(obj: cofeWater)
print(cofeWaterAndSugar.cost)

let cofeMilkAndWhip = Whip(obj: cofeWaterAndMilk)
print(cofeMilkAndWhip.cost)
