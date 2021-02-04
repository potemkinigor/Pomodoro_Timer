//
//  InfoView.swift
//  Pomodoro
//
//  Created by User on 04.02.2021.
//

import SwiftUI

struct InfoView: View {
    
    @Binding var isPresented: Bool
    
    let numberFont = Font.custom("San Francisco", size: 25)
    let textFont = Font.custom("San Francisco", size: 20)
    
    var body: some View {
        ZStack {
            Color(backgroundColor)
                .ignoresSafeArea()
            
            ScrollView {
                Spacer()
                VStack(alignment: .center, spacing: 30) {
                    Image("Pomodoropic")
                        .resizable()
                        .frame(width: 350, height: 350, alignment: .top)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 7)
                        .scaledToFit()
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 20) {
                            Text("1")
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.yellow, lineWidth: 4))
                                .font(numberFont)
                            Text("Добавьте список задач")
                                .font(textFont)
                        }
                        
                        HStack(spacing: 20) {
                            Text("2")
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.yellow, lineWidth: 4))
                                .font(numberFont)
                            Text("Перейдите в настройки и установите параметры работы с задачами")
                                .font(textFont)
                        }
                        
                        HStack(spacing: 20) {
                            Text("3")
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.yellow, lineWidth: 4))
                                .font(numberFont)
                            Text("Запустите таймер и начинайте работать!")
                                .font(textFont)
                        }
                        
                        HStack(spacing: 20) {
                            Text("4")
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.yellow, lineWidth: 4))
                                .font(numberFont)
                            Text("Прошло время работы - сделайте перерыв")
                                .font(textFont)
                        }
                        
                        HStack(spacing: 20) {
                            Text("5")
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.yellow, lineWidth: 4))
                                .font(numberFont)
                            Text("Повторяйте шаги 3 и 4 пока не достигните своей цели")
                                .font(textFont)
                        }
                    }.padding()
                }
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(isPresented: .constant(true))
    }
}
