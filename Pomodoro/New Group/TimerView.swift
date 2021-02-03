//
//  TimerView.swift
//  Pomodoro
//
//  Created by Igor Potemkin on 16.01.2021.
//

import SwiftUI
import CoreData

struct TimerView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var tasks: FetchedResults<Task>
    
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var timerManager: TimerManager

    @State private var timerIsWorking: TimerMode = .initial
    @State private var showNoTaskAlert = false
    @State private var taskName = "Прочее"
    @State private var numberOfTargetPomodors = 0
    @State private var numberOfActualPomodors = 0
    @State private var foregroundColor: Color = Color.white
    
    var body: some View {
        
        ZStack {
            Color(backgroundColor).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 45) {

                Text(timerManager.taskName)
                    .font(.title)
                    .foregroundColor(.black)
                
                ZStack {
                    
                    RoundTimerView()
                        .padding()
                    
                    Text(timerManager.timeStamp)
                        .fontWeight(.bold)
                        .font(.system(size: 75))
                        .foregroundColor(.black)
                }
      
                Divider()
               
                HStack {
                    Button(timerManager.timerMode == .running ? "Остановить" : "Старт", action: {
                        timerManager.timerMode == .running ? timerManager.pauseTimer() : timerManager.startTimer()
                    })
                    .frame(width: 300, height: 75, alignment: .center)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.title2)
                    .cornerRadius(25)
                    .shadow(radius: 10)
                    
                    Button("Х", action: {
                        timerManager.missTask()
                    })
                    .frame(width: 70, height: 75, alignment: .center)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .font(.title2)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }

                Text("Выполнение цели: \(timerManager.numberOfActualPomodors)/\(numberOfTargetPomodors)")
                    .font(.title2)
                    .foregroundColor(.black)
                
            }
            .alert(isPresented: $showNoTaskAlert) {() -> Alert in
                Alert(title: Text("Предупреждение"), message: Text("Задача не выбрана!"), dismissButton: .cancel(Text("Ок")))
            }
            .padding(.bottom)
            .onAppear() {
                numberOfActualPomodors = getNumberOfAllCompletedTodayTasks()
                numberOfTargetPomodors = getTargetNumberOfPomodors()
                
                if timerManager.timerMode == .initial {
                    timerManager.timeStamp = timerManager.convertToTimeStamp(totalSecondsLeft: timerManager.updateTimerSecondsLeft(mode: timerManager.timerTask))
                }
                
            }
        }
    
    }

}

struct TimerView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewContext = PersistenceContainer.shared.container.viewContext
        
        let newTask = Task(context: viewContext)
        newTask.name = "Прочее"
        newTask.isFinished = false
        newTask.countPomidorsActual = 0
        newTask.dateFinished = nil
        newTask.currentlyWorking = true
        
        saveCoreData()
    
         return TimerView()
            .environmentObject(TimerManager())
            .environmentObject(ModelData())
            .environment(\.managedObjectContext, viewContext)
    }
}
