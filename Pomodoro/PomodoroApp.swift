//
//  PomodoroApp.swift
//  Pomodoro
//
//  Created by Igor Potemkin on 13.01.2021.
//

import SwiftUI
import CoreData
import UserNotifications

@main
struct PomodoroApp: App {
    
    @StateObject private var modelData = ModelData()
    @StateObject private var timerManager = TimerManager()
    @StateObject private var barChartData = BarChartData()
    
    let persistanceContainer = PersistenceContainer.shared
    
    var body: some Scene {
        WindowGroup {
            
            ContentView().onAppear(perform: checkData)
                .environmentObject(modelData)
                .environmentObject(timerManager)
                .environmentObject(barChartData)
                .environment(\.managedObjectContext, persistanceContainer.container.viewContext)
        }
    }
    
    func checkData () {
        requestUserNotificationsRequest()
        checkCoreData()
        checkWorkingTask()
        updateTimerStatus()
        updatePropertiesStatus()
        barChartData.updateData(startDate: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, endDate: Date())
    }
    
    func requestUserNotificationsRequest () {
        let usernotifictaion = UNUserNotificationCenter.current()
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        usernotifictaion.requestAuthorization(options: options) { (didAllow, error) in
            if error == nil {
                print("Finished with error: \(String(describing: error?.localizedDescription))")
            } else {
                if !didAllow {
                    print("Decliened by user")
                }
            }
        }
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
        timerManager.timerColor = Color.red
        timerManager.rateTaskCompleted = 1
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
            for index in 0..<modelData.settings.count {
                let newSetting = Propertie(context: viewContext)
                newSetting.id = Int16(modelData.settings[index].id)
                newSetting.name = modelData.settings[index].name
                newSetting.duration = Int32(modelData.settings[index].duration)
                newSetting.postfix = modelData.settings[index].postfix
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
