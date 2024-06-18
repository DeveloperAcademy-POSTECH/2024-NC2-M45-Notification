//
//  AddNotificationView.swift
//  Norou
//
//  Created by Cho YeonJi on 6/17/24.
//

import SwiftUI

struct AddNotificationView: View {
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var isCalendarNoti = false
    @State private var isLocationNoti = false
    @State private var date = Date()
    
    // 몇 회 반복할 지 정할 때 Menu Picker 만들기 위함.
    @State private var selectedRepeat = "Never"
    let repeatCycles = ["반복 안함", "매일", "매주", "2주에 한 번", "매달", "매년"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("알림 이름") {
                        TextField("알림 이름을 입력해주세요.", text: $title)
                    }
                    
                    Section("알림 설명") {
                        ZStack {
                            TextEditor(text: $description)
                                .frame(height: 100)
                            
                            if description.isEmpty {
                                VStack {
                                    HStack {
                                        Text("간단한 알림 설명을 작성해주세요.")
                                            .foregroundStyle(.tertiary)
                                            .padding(.top)
                                        
                                        Spacer()
                                    }
                                    
                                    Spacer()
                                    
                                }
                            }
                        }
                    }
                    
                    Section("날짜 지정 알림") {
                        HStack {
                            DatePicker("", selection: $date)
                            
                            Toggle(isOn: $isCalendarNoti) {
                            }
                        }

                        Picker("반복", selection: $selectedRepeat) {
                            ForEach(repeatCycles, id: \.self) { repeatCycle in
                                Text("\(repeatCycle)")
                                
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("현재 위치") {
                        Toggle(isOn: $isLocationNoti) {
                            Text("장소 도착시 알람")
                        }
                        Text("현재 위치 좌표")
                    }
                    
                }
            }
            .navigationBarTitle("Make Your Norou!")
            
            .navigationBarItems(trailing:
                                    Button("Save"){
                print("Saved Your Norou!")
            })
        }
    }
}

#Preview {
    AddNotificationView()
}
