//
//  Persistance.swift
//  Pomodoro
//
//  Created by Igor Potemkin on 22.01.2021.
//

import CoreData
import SwiftUI



struct PersistenceContainer {
    
    static let shared = PersistenceContainer()
    
    let container: NSPersistentContainer
    
    init () {
        container = NSPersistentContainer(name: "Data")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error)")
            }
        }
    }

}

public func saveCoreData () {
    
    let viewContext = PersistenceContainer.shared.container.viewContext
    
    do {
        try viewContext.save()
    } catch {
        let error = error as NSError
        fatalError("Unresolved error: \(error)")
    }
}

public func getNumberOfAllCompletedTodayTasks () -> Int {
    
    let viewContext = PersistenceContainer.shared.container.viewContext
    
    let calendar = Calendar(identifier: .gregorian)
    let currentDate = Date()
    
    let startOfTheDay = calendar.startOfDay(for: currentDate)
    let endOfTheDay =  calendar.date(byAdding: .day, value: 1, to: currentDate)!
    
    let request = CompletedPomodoros.fetchRequest() as NSFetchRequest<CompletedPomodoros>
    let pred = NSPredicate(format: "(date >= %@) AND (date <= %@)", startOfTheDay as NSDate, endOfTheDay as NSDate)
    
    request.predicate = pred
    
    let listOfTodaysEndedTasks = try! viewContext.fetch(request)
    
    return listOfTodaysEndedTasks.count
}

public func getTargetNumberOfPomodors () -> Int {
    
    let viewContext = PersistenceContainer.shared.container.viewContext
    
    let requestProperty = Propertie.fetchRequest() as NSFetchRequest<Propertie>
    let pred = NSPredicate(format: "name == 'Дневная цель'")
    
    requestProperty.predicate = pred
    
    let targetPomodors = try! viewContext.fetch(requestProperty)
    
    return Int(targetPomodors[0].duration)
}

public func getTargetNumberOfPomodorsForLongBrake () -> Int {
    
    let viewContext = PersistenceContainer.shared.container.viewContext
    
    let requestProperty = Propertie.fetchRequest() as NSFetchRequest<Propertie>
    let pred = NSPredicate(format: "name == 'Длинный перерыв после'")
    
    requestProperty.predicate = pred
    
    let targetPomodors = try! viewContext.fetch(requestProperty)
    
    return Int(targetPomodors[0].duration)
}

public func getWorkingTask () -> Task? {
    let viewContext = PersistenceContainer.shared.container.viewContext
    
    let request = Task.fetchRequest() as NSFetchRequest<Task>
    let pred = NSPredicate(format: "currentlyWorking == true")
    request.predicate = pred
    
    let workingTask = try! viewContext.fetch(request)
    
    return workingTask[0]
}

public func makeOtherTaskWorking () {
    let viewContext = PersistenceContainer.shared.container.viewContext
    
    let request = Task.fetchRequest() as NSFetchRequest<Task>
    let pred = NSPredicate(format: "name == 'Прочее'")
    request.predicate = pred
    
    let workingTask = try! viewContext.fetch(request)
    
    workingTask[0].currentlyWorking = true
    
    saveCoreData()
}

