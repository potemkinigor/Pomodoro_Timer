//
//  Tasks.swift
//  Pomodoro
//
//  Created by Igor Potemkin on 13.01.2021.
//

import Combine
import Foundation
import CoreData

struct Property: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var duration: Int
    var postfix: String
}

class ModelData: ObservableObject {
    @Published var settings: [Property] = [
        Property(id: 1, name: "Рабочий интервал", duration: 1, postfix: "Минут"),
        Property(id: 2, name: "Короткий перерыв", duration: 5, postfix: "Минут"),
        Property(id: 3, name: "Длинный перерыв", duration: 15, postfix: "Минут"),
        Property(id: 5, name: "Дневная цель", duration: 8, postfix: "Помидор"),
        Property(id: 4, name: "Длинный перерыв после", duration: 4, postfix: "Помидор")
    ]
    
    @Published var coreDataSettings: [Property] = []
}




