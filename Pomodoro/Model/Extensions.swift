//
//  Extensions.swift
//  Pomodoro
//
//  Created by User on 01.02.2021.
//

import Foundation
import SwiftUI

//MARK: - Dates

extension Date {
    func getDatesBetweenTwoDates(from startDate: Date, to endDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = startDate
                
        while date <= endDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        
        return dates
    }
}

//MARK: - NavigationBars

extension UINavigationBarAppearance {
    func setColor(title: UIColor? = nil, background: UIColor? = nil) {
            configureWithTransparentBackground()
            if let titleColor = title {
                largeTitleTextAttributes = [.foregroundColor: titleColor]
                titleTextAttributes = [.foregroundColor: titleColor]
            }
            backgroundColor = background
            UINavigationBar.appearance().scrollEdgeAppearance = self
            UINavigationBar.appearance().standardAppearance = self
        }
}

//MARK: - TabBar

extension UITabBarAppearance {
    func setColor(background: UIColor? = nil) {
            backgroundColor = background
        }
}

//MARK: - Screen

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

