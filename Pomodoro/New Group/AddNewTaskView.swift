//
//  AddNewTaskView.swift
//  Pomodoro
//
//  Created by Igor Potemkin on 15.01.2021.
//

import SwiftUI

struct AddNewTaskView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var tasks: FetchedResults<Task>
    
    @EnvironmentObject var modelData: ModelData
    @State var taskName: String = ""
    @State var taskForecastPomodoro: Int = 0
    @Binding var isPresented: Bool
    
    let pomidoroEmojiString: String = "\u{1F345}"
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("Наименование задачи")
                    .font(.title2)
                TextField("", text: $taskName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .shadow(radius: 10)
            }
            
            .padding()
            
            VStack(alignment: .center) {
                
                HStack {
                    Button("Записать задачу", action: {
                        withAnimation {
                            let newTask = Task(context: viewContext)
                            newTask.name = taskName
                            newTask.isFinished = false
                            newTask.countPomidorsActual = 0
                            newTask.dateFinished = nil
                            newTask.currentlyWorking = false
                            newTask.dateCreated = Date()
                            saveCoreData()
                            isPresented.toggle()
                        }
                    })
                    .frame(width: 300, height: 75, alignment: .center)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.title2)
                    .cornerRadius(25)
                    .shadow(radius: 10)
                    
                    Button("Х", action: {
                        isPresented.toggle()
                    })
                    .frame(width: 70, height: 75, alignment: .center)
                    .background(Color.red)
                    .foregroundColor(Color(taskColor))
                    .font(.title2)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(10)
        .shadow(radius: 20)
    }
}

struct AddNewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTaskView(isPresented: .constant(true))
            .environmentObject(ModelData())
    }
}
