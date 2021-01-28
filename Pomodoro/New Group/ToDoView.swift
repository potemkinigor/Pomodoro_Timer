//
//  ToDoView.swift
//  Pomodoro
//
//  Created by Igor Potemkin on 13.01.2021.
//

import SwiftUI
import CoreData

struct ToDoView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Task.dateCreated, ascending: false)])
    private var tasks: FetchedResults<Task>
    
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var timerManager: TimerManager
    
    @State private var showAddTask: Bool = false
    @State private var editMode = EditMode.inactive
    @State private var presentWorkingTimerAlert = false
    
    @Binding var tabSelection: String
    
    private var addButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(Button(action: onAdd) { Image(systemName: "plus") })
        default:
            return AnyView(EmptyView())
        }
    }
    
    func onAdd() {
        showAddTask.toggle()
    }
    
    func addTaskToCoreData (taskName: String) {
        let newTask = Task(context: viewContext)
        newTask.name = taskName
        newTask.isFinished = false
        newTask.countPomidorsActual = 0
        newTask.dateFinished = nil
        newTask.currentlyWorking = false
        saveCoreData()
    }
    
    func changeWorkingTask (task: Task) {
        let request = Task.fetchRequest() as NSFetchRequest<Task>
        let pred = NSPredicate(format: "currentlyWorking == true")
        request.predicate = pred
        
        let workingTask = try! viewContext.fetch(request)
        
        for task in workingTask {
            task.currentlyWorking = false
        }
        
        task.currentlyWorking = true
        
        saveCoreData()
        
    }
    
    var body: some View {
        
        VStack {
        NavigationView {
            List {
                ForEach (tasks) {task in
                    if !task.isFinished  {
                        HStack {
                            if task.name != "Прочее" {
                                Button(action: {
                                    let currentDate = Date()
                                    task.dateFinished = currentDate
                                    task.isFinished = true
                                    saveCoreData()
                                }) {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(.green)
                                }
                                    .buttonStyle(BorderlessButtonStyle())
                            }
                            Text(task.name ?? "Untitled")
                            Spacer()
                            Text(String(task.countPomidorsActual))
                            Button(">", action: {
                                if timerManager.timerMode == .initial {
                                    timerManager.taskName = getWorkingTask()!.name!
                                    tabSelection = "TimerView"
                                    changeWorkingTask(task: task)
                                } else {
                                    presentWorkingTimerAlert.toggle()
                                }
                            })
                            .frame(width: 30, height: 30)
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
                .onDelete(perform: deleteTask)
                .onTapGesture {
                    showAddTask = false
                }
            }
            .ignoresSafeArea(edges: .all)
            .navigationBarTitle("Задачи")
            .navigationBarItems(trailing: addButton)
            .overlay(showAddTask ?
                        AddNewTaskView(isPresented: $showAddTask)
                        : nil)

        }
            
            
        }.alert(isPresented: $presentWorkingTimerAlert) { () -> Alert in
            Alert(title: Text("Предупреждение"),
                  message: Text("Идет выполненение другой задачи"),
                  dismissButton: .cancel(Text("Ок"))
            )
        }

    }
    
    func deleteTask (at offsets: IndexSet) {
        withAnimation {
            
            offsets.forEach { index in
                let task = self.tasks[index]
                if task.currentlyWorking {
                    makeOtherTaskWorking()
                }
            }
            
            
            
            offsets.map { tasks[$0] }.forEach(viewContext.delete)
            saveCoreData()
        }
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewContext = PersistenceContainer.shared.container.viewContext
        
        let newTask = Task(context: viewContext)
        newTask.name = "Прочее"
        newTask.isFinished = false
        newTask.countPomidorsActual = 0
        newTask.dateFinished = nil
        newTask.currentlyWorking = false
        
        saveCoreData()
        
        return ToDoView(tabSelection: .constant("ToDoView"))
            .environmentObject(ModelData())
            .environmentObject(TimerManager())
    }
}
