//
//  Fabric&Template.swift
//  
//
//  Created by Anton Fomkin on 08.11.2019.
//

import Foundation


// Мой пример использования паттернов Template и Factory. Фабрика создает необходимый транспортный объект в зависимости
// от веса груза.
//Решение масштабируемое, как с точки зрения конкретных свойств и методов транспорта, так и с точки зрения добавления
//новых видов транспорта и дополнительных методов, присущих протоколу и/или конкретному транспортному объекту.

struct Transport {
    let name: String
}

class Template {
    var tonnage: Float = 0.0
    func infoOfTonnage() {}
}

protocol Logistik {
    var transportName: Transport { get }
    func startLoad()
}


final class Truck: Template,Logistik {
    let transportName = Transport(name: "Грузовой автомобиль")
    func startLoad() {
        print("Вид транспорта:\(transportName.name). Загрузка начата")
        infoOfTonnage()
    }
    
    override var tonnage:Float {
        get { return 20.0 }
        set { super.tonnage = super.tonnage }
    }
    
    override func infoOfTonnage() {
        print("Максимальная грузоподьемность - \(tonnage)\n")
    }
}

final class Ship: Template,Logistik {
    let transportName = Transport(name: "Корабль")
    func startLoad() {
        print("Вид транспорта:\(transportName.name). Загрузка начата")
        infoOfTonnage()
    }
    
    override var tonnage:Float {
        get { return 600.0 }
        set { super.tonnage = super.tonnage }
    }
  
    override func infoOfTonnage() {
        print("Максимальная грузоподьемность - \(tonnage)\n")
    }
}
    
final class Factory {
    
    func loadToTransport (_ weight: Float) -> Logistik {
         if weight > 20.0 {
            return Ship()
         } else {
            return Truck()
         }
    }
}
    
let fabric = Factory()
var transport: Logistik

transport = fabric.loadToTransport(50.0)
transport.startLoad()


transport = fabric.loadToTransport(10.0)
transport.startLoad()


    
