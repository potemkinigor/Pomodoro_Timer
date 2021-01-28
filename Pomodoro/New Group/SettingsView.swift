//
//  ManageSettingsView.swift
//  Pomodoro
//
//  Created by Igor Potemkin on 18.01.2021.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var properties: FetchedResults<Propertie>
    
    @EnvironmentObject var modelData: ModelData
    @State private var showOther: Bool = false
    
    var body: some View {
        
        VStack(spacing: 20) {
            List {
                ForEach (properties) {property in
                    HStack {
                        Text(property.name!)
                            .font(.title)
                        Spacer()
                        Text(String(property.duration))
                            .font(.title)
                        Text(String(property.postfix!))
                            .font(.title3)
                    }
                    HStack {
                        Button("+", action: {
                            property.duration += 1
                            saveCoreData()
                            updateSettings ()
                        })
                        .frame(width: 150,height: 40)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .font(.title)
                        .cornerRadius(5)
                        .shadow(radius: 10)
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Spacer()
                    
                        Button("-", action: {
                            if property.duration > 1 {
                                property.duration -= 1
                                saveCoreData()
                                updateSettings ()
                            }
                        })
                        .frame(width: 150,height: 40)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .font(.title)
                        .cornerRadius(5)
                        .shadow(radius: 10)
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    
                }
                
                Spacer()
                
            }
        }
    }
    
    func updateSettings () {
        
        let viewContext = PersistenceContainer.shared.container.viewContext
        
        for i in 0...(modelData.coreDataSettings.count - 1) {
            let requestSettings = Propertie.fetchRequest() as NSFetchRequest<Propertie>
            let pred = NSPredicate(format: "name CONTAINS %@", modelData.coreDataSettings[i].name)
            requestSettings.predicate = pred
            let listOfProperties = try! viewContext.fetch(requestSettings)
            modelData.coreDataSettings[i].duration = Int(listOfProperties[0].duration)
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ModelData())
    }
}
