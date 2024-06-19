//
//  AddNotificationView.swift
//  Norou
//
//  Created by Cho YeonJi on 6/17/24.
//

import SwiftUI
import SwiftData
import UserNotifications

struct AddNotificationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var isCalendarNoti = false
    @State private var isLocationNoti = false
    @State private var date = Date()
    @State private var selectedRepeat = "반복 안함"
    let repeatCycles = ["반복 안함", "매일", "매주", "2주에 한 번", "매달", "매년"]

    var routine: Routine?
    
    init(routine: Routine? = nil) {
        self.routine = routine
        if let routine = routine {
            _title = State(initialValue: routine.title ?? "")
            _description = State(initialValue: routine.content ?? "")
            _isCalendarNoti = State(initialValue: routine.isCalendarNoti)
            _isLocationNoti = State(initialValue: routine.isLocationNoti)
            _date = State(initialValue: routine.date ?? Date())
            _selectedRepeat = State(initialValue: routine.repeatCycles ?? "반복 안함")
        }
    }
    var body: some View {
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
                                Button("Save") {
            saveNotification()
        }
        )
        .onAppear {
            requestNotificationPermission()
        }
    }
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("권한 요청 에러: \(error)")
            } else if granted {
                print("권한 요청 승인")
            } else {
                print("권한 요청 거부")
            }
        }
    }
    private func saveNotification() {
        if let routine = routine {
            routine.title = title
            routine.content = description
            routine.date = isCalendarNoti ? date : date
            routine.isCalendarNoti = isCalendarNoti
            routine.repeatCycles = selectedRepeat
            routine.isLocationNoti = isLocationNoti
        } else {
            let newRoutine = Routine(
                title: title,
                content: description,
                date: isCalendarNoti ? date : date,
                isCalendarNoti: isCalendarNoti,
                repeatCycles: selectedRepeat,
                isLocationNoti: isLocationNoti
            )
            modelContext.insert(newRoutine)
        }
        scheduleNotification()
        presentationMode.wrappedValue.dismiss()
        print("저장 성공")
    }
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = description
        content.sound = UNNotificationSound.default
        
        var trigger: UNNotificationTrigger?
        
        if isCalendarNoti {
            var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            
            switch selectedRepeat {
            case "매일":
                dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
                trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            case "매주":
                dateComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
                trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            case "2주에 한 번":
                dateComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2 * 7 * 24 * 60 * 60, repeats: true)
                trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            case "매달":
                dateComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
                trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            case "매년":
                dateComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: date)
                trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            default:
                trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            }
        }
        
        if let trigger = trigger {
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("알림 설정 에러: \(error)")
                } else {
                    print("알림 설정 성공")
                }
            }
        } else {
            print("알림 설정 실패")
        }
    }
}

#Preview {
    AddNotificationView()
}





