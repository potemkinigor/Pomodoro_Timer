//
//  PomodoroApp.swift
//  Pomodoro
//
//  Created by Igor Potemkin on 13.01.2021.
//

import SwiftUI
import CoreData

@main
struct PomodoroApp: App {
    
    @StateObject private var modelData = ModelData()
    @StateObject private var timerManager = TimerManager()
    
    let persistanceContainer = PersistenceContainer.shared
    
    var body: some Scene {

        WindowGroup {
            
            ContentView().onAppear(perform: checkData)
                .environmentObject(modelData)
                .environmentObject(timerManager)
                .environment(\.managedObjectContext, persistanceContainer.container.viewContext)
        }
    }
    
    func checkData () {
        checkCoreData()
        checkWorkingTask()
        updateTimerStatus()
        updatePropertiesStatus()
    }
    
    func checkWorkingTask () {
        if getWorkingTask() == nil {
            makeOtherTaskWorking()
        }
    }
    
    func updatePropertiesStatus() {
        let viewContext = PersistenceContainer.shared.container.viewContext
        let requestProperties = Propertie.fetchRequest() as NSFetchRequest<Propertie>
        
        let listOfCoreDataProperties = try! viewContext.fetch(requestProperties)
        
        var index = 1
        
        for element in listOfCoreDataProperties {
            let newProperty = Property(id: index, name: element.name!, duration: Int(element.duration), postfix: element.postfix!)
            modelData.coreDataSettings.append(newProperty)
            index += 1
        }
    }
    
    func updateTimerStatus () {
        timerManager.timerMode = .initial
        timerManager.timerTask = .task
        timerManager.totalSecondsLeft = timerManager.updateTimerSecondsLeft(mode: .task)
        timerManager.timeStamp = timerManager.convertToTimeStamp(totalSecondsLeft: timerManager.totalSecondsLeft)
        timerManager.numberOfActualPomodors = getNumberOfAllCompletedTodayTasks()
        timerManager.taskName = getWorkingTask()!.name!
    }
    
    func checkCoreData () {
        
        let viewContext = PersistenceContainer.shared.container.viewContext
        
        let requestTask = Task.fetchRequest() as NSFetchRequest<Task>
        let requestSettings = Propertie.fetchRequest() as NSFetchRequest<Propertie>
        
        let listOfTasks = try! viewContext.fetch(requestTask)
        let listOfProperties = try! viewContext.fetch(requestSettings)
        
        let pred = NSPredicate(format: "name CONTAINS %@", "прочее")
        
        requestSettings.predicate = pred
        
        if listOfProperties.count == 0 {
            for setting in modelData.settings {
                let newSetting = Propertie(context: viewContext)
                newSetting.name = setting.name
                newSetting.duration = Int32(setting.duration)
                newSetting.postfix = setting.postfix
            }
        }
    
        saveCoreData()
        
        if listOfTasks.count == 0 {
            let newTask = Task(context: viewContext)
            newTask.name = "Прочее"
            newTask.isFinished = false
            newTask.countPomidorsActual = 0
            newTask.dateFinished = nil
            newTask.currentlyWorking = true
            
            saveCoreData()
            
        } else {
            listOfTasks[0].currentlyWorking = true
            saveCoreData()
        }
        
        
        
    }
}
