//
//  ContentView.swift
//  Pomodoro
//
//  Created by Igor Potemkin on 13.01.2021.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var timerManager: TimerManager
    @EnvironmentObject var barChartData: BarChartData
    
    @State private var tabSelection = "ToDoView"
    
    init() {
        UITabBar.appearance().barTintColor = backgroundColor
    }
    
    var body: some View {        
        VStack {            
            TabView(selection: $tabSelection) {
                ToDoView(tabSelection: $tabSelection)
                     .tabItem {
                        Image(systemName: "play")
                        Text("В работе")
                     }.tag("ToDoView")
                TimerView()
                    .tabItem {
                        Image(systemName: "timer")
                        Text("Таймер")
                            .foregroundColor(Color.red)
                    }.tag("TimerView")
                FullListOfTasks()
                    .tabItem {
                        Image(systemName: "list.star")
                        Text("Завершенные")
                    }.tag("FullListOfTasks")
                Statistics()
                    .tabItem {
                        Image(systemName: "function")
                        Text("Статистика")
                    }.tag("Statistics")
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Настройки")
                    }.tag("Settings")
                    
            }
            .ignoresSafeArea(edges: .top)
        }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            timerManager.dateLeavedApp = Date()
            
            if timerManager.timerMode == .running {
                let usernotifictaion = UNUserNotificationCenter.current()
                let notification = UNMutableNotificationContent()
                var timerBodyText = ""
                
                if timerManager.timerTask == .task {
                    timerBodyText = "Время задачи закончилось"
                } else {
                    timerBodyText = "Время отдыха закончилось"
                }
                
                notification.title = "Таймер завершен"
                notification.body = timerBodyText
                notification.badge = 1
                notification.sound = UNNotificationSound.default
                
                let timeToNotify = Date(timeIntervalSinceNow: TimeInterval(timerManager.totalSecondsLeft))
                let triggerDate = Calendar.current.dateComponents([.year, .month,.day, .hour, .minute, .second], from: timeToNotify)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                
                let identifyer = "Timer identifyer"
                let request = UNNotificationRequest(identifier: identifyer, content: notification, trigger: trigger)
                
                usernotifictaion.add(request) { (error) in
                    if let error = error {
                            print("Error \(error.localizedDescription)")
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            timerManager.dateEnteredApp = Date()
            
            let differenceInSeconds = Int(timerManager.dateEnteredApp.timeIntervalSince(timerManager.dateLeavedApp))
            
            if (differenceInSeconds > timerManager.totalSecondsLeft) && (timerManager.timerMode == .running) {
                timerManager.totalSecondsLeft = 1
            } else if timerManager.timerMode == .running {
                timerManager.totalSecondsLeft -= differenceInSeconds
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
            .environmentObject(TimerManager())
    }
}
