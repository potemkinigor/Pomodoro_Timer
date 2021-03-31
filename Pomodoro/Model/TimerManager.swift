//
//  TimerManager.swift
//  Pomodoro
//
//  Created by Igor Potemkin on 18.01.2021.
//

import Foundation
import SwiftUI
import Combine
import CoreData

enum TimerMode {
    case initial
    case running
    case paused
}

enum WorkingTask {
    case task
    case shortBrake
    case longBreak
}

class TimerManager: ObservableObject {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var tasks: FetchedResults<Task>
    
    @EnvironmentObject var modelData: ModelData
    
    //MARK: - Timer public properties
    
    @Published var timerMode: TimerMode = .initial
    @Published var timerTask: WorkingTask = .task
    @Published var taskName: String = "Прочее"
    @Published var timeStamp = "\(ModelData().settings[0].duration) : 00"
    @Published var numberOfActualPomodors = 0
    @Published var totalSecondsLeft = 0
    @Published var timerColor = Color.red
    @Published var rateTaskCompleted: CGFloat = 1
    
    @Published var dateLeavedApp: Date = Date()
    @Published var dateEnteredApp: Date = Date()
    
    
    var timer = Timer()
    
    //MARK: - Public functions
    
    func startTimer () {
        timerMode = .running
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [self] timer in
            if self.totalSecondsLeft == 0 {
                if timerTask == .task && getNumberOfAllCompletedTodayTasks () % getTargetNumberOfPomodorsForLongBrake () == 0 && getNumberOfAllCompletedTodayTasks () != 0  {
                    addPomodorToTask()
                    timerMode = .initial
                    dropTimerToLongBreak()
                } else if timerTask == .task {
                    addPomodorToTask()
                    timerMode = .initial
                    dropTimerToShortBreak()
                } else {
                    timerMode = .initial
                    dropTimerToTask()
                }
                rateTaskCompleted = 1
                return
            }
            self.totalSecondsLeft -= 1
            updateTimerView()
            
            timeStamp = convertToTimeStamp(totalSecondsLeft: totalSecondsLeft)
            
        })
    }
    
    func pauseTimer () {
        self.timerMode = .paused
        timer.invalidate()
        invalidatePushNotification()
    }
    
    func dropTimerToTask () {
        totalSecondsLeft = updateTimerSecondsLeft(mode: .task)
        timerTask = .task
        timeStamp = convertToTimeStamp(totalSecondsLeft: totalSecondsLeft)
        updateTimerView()
        timer.invalidate()
    }
    
    func dropTimerToShortBreak () {
        totalSecondsLeft = updateTimerSecondsLeft(mode: .shortBrake)
        timerTask = .shortBrake
        timeStamp = convertToTimeStamp(totalSecondsLeft: totalSecondsLeft)
        updateTimerView()
        timer.invalidate()
        invalidatePushNotification()
    }
    
    func dropTimerToLongBreak () {
        totalSecondsLeft = updateTimerSecondsLeft(mode: .longBreak)
        timerTask = .longBreak
        timeStamp = convertToTimeStamp(totalSecondsLeft: totalSecondsLeft)
        updateTimerView()
        timer.invalidate()
        invalidatePushNotification()
    }
    
    func missTask () {
        timer.invalidate()
        dropTimerToTask()
        timerMode = .initial
        timerTask = .task
        updateTimerView()
        invalidatePushNotification()
    }
    
    func convertToTimeStamp (totalSecondsLeft: Int) -> String {
        let minutes = "\((totalSecondsLeft % 3600) / 60)"
        let seconds = "\((totalSecondsLeft % 3600) % 60)"
        let minuteStamp = minutes.count > 1 ? minutes : "0" + minutes
        let secondStamp = seconds.count > 1 ? seconds : "0" + seconds
        
        return "\(minuteStamp) : \(secondStamp)"
    }
    
    func updateTimerSecondsLeft (mode: WorkingTask) -> Int {
        
        var textForRequest: String
        
        switch mode {
        case .task:
            textForRequest = "Рабочий интервал"
        case .shortBrake:
            textForRequest = "Короткий перерыв"
        case .longBreak:
            textForRequest = "Длинный перерыв"
        }

        let viewContext = PersistenceContainer.shared.container.viewContext
        
        let requestSetting = Propertie.fetchRequest() as NSFetchRequest<Propertie>
        let pred = NSPredicate(format: "name == %@", textForRequest)
        
        requestSetting.predicate = pred
        
        let settingWithTotalTime = try! viewContext.fetch(requestSetting)
        
        return Int(settingWithTotalTime[0].duration) * 60
    }
    
    //MARK: - Private functions
    
    private func addPomodorToTask () {
        
        let viewContext = PersistenceContainer.shared.container.viewContext
        
        let request = Task.fetchRequest() as NSFetchRequest<Task>
        let pred = NSPredicate(format: "currentlyWorking == true")
        request.predicate = pred
        
        let workingTask = try! viewContext.fetch(request)
        
        
        let newEntry = CompletedPomodoros(context: viewContext)
        newEntry.date = Date()
        newEntry.totalAmount = 1
        workingTask[0].completedPomodoros = NSSet.init(array: [newEntry])
        
        workingTask[0].countPomidorsActual += 1
        
        saveCoreData()
        
        numberOfActualPomodors = getNumberOfAllCompletedTodayTasks ()
    }
    
    private func updateTimerView() {
        switch timerTask {
        case .task:
            timerColor = Color.red
            rateTaskCompleted = CGFloat(Double(totalSecondsLeft) / Double(updateTimerSecondsLeft(mode: .task)))
        case .longBreak:
            timerColor = Color.green
            rateTaskCompleted = CGFloat(Double(totalSecondsLeft) / Double(updateTimerSecondsLeft(mode: .longBreak)))
        case .shortBrake:
            timerColor = Color.green
            rateTaskCompleted = CGFloat(Double(totalSecondsLeft) / Double(updateTimerSecondsLeft(mode: .shortBrake)))
        }
    }
    
    private func invalidatePushNotification () {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["Timer identifyer"])
    }
    
}
