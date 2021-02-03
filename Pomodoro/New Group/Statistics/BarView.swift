//
//  BarView.swift
//  Pomodoro
//
//  Created by User on 29.01.2021.
//

import SwiftUI

struct BarView: View, Hashable {
    
    var amountOfPomodors: CGFloat = 0
    var xAxisName: String = ""
    var completedPomodors: Int = 0
    
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Capsule().frame(width: 30, height: CGFloat(barChartHeight))
                    .foregroundColor(Color.white.opacity(0.3))
                Capsule().frame(width: 30, height: amountOfPomodors)
                    .foregroundColor(Color.white)
                Text("\(completedPomodors)")
                    .font(Font.custom("Times New Roman" , size: 13))
            }
            Text(xAxisName)
                .font(Font.custom("Times New Roman" , size: 11))
                .foregroundColor(.black)
        }.onAppear()
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView()
    }
}
