//
//  Statistics.swift
//  Pomodoro
//
//  Created by User on 29.01.2021.
//

import SwiftUI

struct Statistics: View {
    
    @EnvironmentObject var barChartData: BarChartData
    
    @State private var pickerSelectedItem = 0
    @State private var startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    @State private var endDate = Date()
    
    var body: some View {
        ZStack {
            Color(backgroundColor).edgesIgnoringSafeArea(.all)
            VStack(spacing: 25) {
                Text("Статистика")
                .font(.system(size: 28))
                .fontWeight(.medium)
                .foregroundColor(Color(.black))
                
                HStack {
                    DatePicker("Начальная дата", selection: $startDate, displayedComponents: .date)
                        .foregroundColor(.black)
                        .font(.title2)
                        .onChange(of: startDate) {date in
                            barChartData.updateData(startDate: startDate, endDate: endDate)
                        }
                }
                .padding()
                
                HStack {
                    DatePicker("Конечная дата", selection: $endDate, displayedComponents: .date)
                        .foregroundColor(.black)
                        .font(.title2)
                        .onChange(of: endDate) {date in
                            barChartData.updateData(startDate: startDate, endDate: endDate)
                        }
                }
                .padding()
        
                ScrollView(.horizontal) {
                    HStack(alignment: .bottom) {   
                        ForEach(barChartData.barCharts, id:\.self) {element in
                            element
                        }
                    }
                    .padding()
                }.onAppear {
                    barChartData.updateData(startDate: startDate, endDate: endDate)
                }
            }
        }
    }
    
}

struct Statistics_Previews: PreviewProvider {
    static var previews: some View {
        Statistics()
    }
}
