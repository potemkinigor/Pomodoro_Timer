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
    
    @State private var tabSelection = "ToDoView"
    
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
                Text("Statistics")
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
