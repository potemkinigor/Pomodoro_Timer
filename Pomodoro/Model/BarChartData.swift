//
//  BarChart.swift
//  Pomodoro
//
//  Created by User on 29.01.2021.
//

import Foundation
import SwiftUI
import Combine
import CoreData

class BarChartData: ObservableObject {

    @Published var barCharts: [BarView] = []
    
    var unsortedDates: [String] = []
    var barChartDataArray: [(String, CGFloat, Int)] = []
    
    //MARK: - private functions

    func findMaxPomodors (list: [String : Int]) -> Int {
        var maxPomodors: Int = 0
        
        for element in list {
            if element.value > maxPomodors {
                maxPomodors = Int(element.value)
            }
        }
        return maxPomodors
    }
    
    func updateBarScaleToMaxPomodors (maxPomodors: Int) -> Double {
        return Double(barChartHeight) / Double(maxPomodors)
    }

    //MARK: - public functions
    
    func updateData (startDate: Date, endDate: Date) {
        
        barChartDataArray.removeAll()
        barCharts.removeAll()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        let datesBetweenChosenDates = Date().getDatesBetweenTwoDates(from: startDate, to: endDate)
        
        for date in datesBetweenChosenDates {
            barChartDataArray.append((dateFormatter.string(from: date), 0, 0))
        }
        
        let viewContext = PersistenceContainer.shared.container.viewContext
        let request = CompletedPomodoros.fetchRequest() as NSFetchRequest<CompletedPomodoros>
        let pred = NSPredicate(format: "date >= %@ && date <= %@", startDate as NSDate, endDate as NSDate)
        request.predicate = pred
        
        let listOfCompletedPomodors = try! viewContext.fetch(request)
        
        if listOfCompletedPomodors.count == 0 {
            return
        }
        
        for element in listOfCompletedPomodors {
            let date = dateFormatter.string(from: element.date!)
            unsortedDates.append(date)
        }
        
        var counts: [String : Int] = [ : ]
        
        for item in unsortedDates {
            counts[item] = (counts[item] ?? 0) + 1
        }
        
        let tranalsteToCGFloatIndex = updateBarScaleToMaxPomodors(maxPomodors: findMaxPomodors(list: counts))
        
        for index in 0..<barChartDataArray.count {
            if counts[barChartDataArray[index].0] != nil {
                barChartDataArray[index].1 = CGFloat(Double(counts[barChartDataArray[index].0]!) * tranalsteToCGFloatIndex)
                barChartDataArray[index].2 = counts[barChartDataArray[index].0]!
            }
        }
        
        for index in 0..<barChartDataArray.count {
            barCharts.append(BarView(amountOfPomodors: barChartDataArray[index].1, xAxisName: barChartDataArray[index].0, completedPomodors: barChartDataArray[index].2))
        }
        
    }
    
}
