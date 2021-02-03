//
//  RoundTimerView.swift
//  Pomodoro
//
//  Created by User on 30.01.2021.
//

import SwiftUI

struct RoundTimerView: View {
    
    @EnvironmentObject var timerManager: TimerManager
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 15.0)
                .opacity(0.4)
                .foregroundColor(Color.gray.opacity(0.7))
            
            Circle()
                .trim(from: 0.0, to: timerManager.rateTaskCompleted)
                .stroke(style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(timerManager.timerColor)
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear)
        }
        .frame(width: 300, height: 300, alignment: .center)
    }
}

struct RoundTimerView_Previews: PreviewProvider {
    static var previews: some View {
        RoundTimerView()
    }
}
