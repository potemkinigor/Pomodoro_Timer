//
//  ToDoView.swift
//  Pomodoro
//
//  Created by Igor Potemkin on 13.01.2021.
//

import SwiftUI

struct FullListOfTasks: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Task.dateFinished, ascending: false)])
    private var tasks: FetchedResults<Task>
    
    @EnvironmentObject var modelData: ModelData
       
    var body: some View {
        NavigationView {
            List {
                ForEach (tasks) {task in
                    if task.isFinished {
                        HStack {
                            Button(action: {
                                task.isFinished = false
                                task.dateFinished = nil
                                saveCoreData()
                            }) {
                                Image(systemName: "return")
                                    .foregroundColor(.green)
                            }
                                .buttonStyle(BorderlessButtonStyle())
                            
                            VStack(alignment: .leading) {
                                Text(task.name ?? "Untitled")
                                    .font(.title2)
                                Text("Завершено: \(changeDateFormat(date: task.dateFinished))")
                                    .font(Font.custom("Times New Roman" , size: 13))
                            }
                            Spacer()
                            Text(String(task.countPomidorsActual))
                        }
                    }
                }
                
            }
            .ignoresSafeArea(edges: .top)
            .navigationTitle("Завершенные задачи")
        }
    }
}

func changeDateFormat (date: Date?) -> String {
    
    guard date != nil else { return "Ошибка извлечения даты"}
    
    let formatter = DateFormatter()
    formatter.timeStyle = .none
    formatter.dateStyle = .medium
    
    return formatter.string(from: date!)
}

struct FullListOfTasks_Previews: PreviewProvider {
    static var previews: some View {
        FullListOfTasks()
            .environmentObject(ModelData())
    }
}
