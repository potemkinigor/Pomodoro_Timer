//
//  PieView.swift
//  Pomodoro
//
//  Created by User on 02.02.2021.
//

import SwiftUI

struct PieView: View {
    var body: some View {
        
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: 200, y: 200))
                path.addArc(center: .init(x: 200, y: 200), radius: 150, startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 15), clockwise: true)
            }
            .fill(Color.green)
            
            Path { path in
                path.move(to: CGPoint(x: 200, y: 200))
                path.addArc(center: .init(x: 200, y: 200), radius: 150, startAngle: Angle(degrees: 15.0), endAngle: Angle(degrees: 360), clockwise: true)
            }
            .fill(Color.red)
        }
        
    }
}

struct PieView_Previews: PreviewProvider {
    static var previews: some View {
        PieView()
    }
}
