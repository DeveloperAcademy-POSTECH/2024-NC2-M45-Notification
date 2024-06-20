//
//  AddNotificationView.swift
//  Norou
//
//  Created by Cho YeonJi on 6/17/24.
//

import CoreLocation
import CoreLocationUI
import SwiftUI
import SwiftData

struct AddNotificationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) private var presentationMode
    @StateObject var locationManager = LocationManager()
    
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
                    .onChange(of: isLocationNoti) { newValue in
                        if newValue == true {
                            if locationManager.authorizationStatus == .authorizedWhenInUse ||
                                locationManager.authorizationStatus == .authorizedAlways {
                                locationManager.requestLocation()
                            } else if locationManager.authorizationStatus == .notDetermined {
                                locationManager.checkAuthorizationStatus()
                            } else {
                                print("위치 권한이 필요합니다.")
                            }
                        } else {
                            resetLocationData()
                        }
                    }
                    
                    if isLocationNoti == true {
                        
                        if let placemark = locationManager.placemark {
                            Text("\(placemark.administrativeArea ?? "알 수 없음") \(placemark.locality ?? "알 수 없음") \(placemark.thoroughfare ?? "알 수 없음") \(placemark.subThoroughfare ?? "알 수 없음") \(placemark.name ?? "알 수 없음")")
                        } else {
                            Text("위치 정보를 가져오는 중...")
                        }
                    } else {
                        Text("토글을 눌러 현재 위치에 있을 때 알림설정")
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
        
        .navigationBarTitle("Make Your Norou!")
        .navigationBarItems(trailing:
                                Button("Save") {
            saveNotification()
        }
        )
    }
    
    private func saveNotification() {
        if let routine = routine {
            routine.title = title
            routine.content = description
            routine.date = isCalendarNoti ? date : date
            routine.isCalendarNoti = isCalendarNoti
            routine.repeatCycles = selectedRepeat
            routine.isLocationNoti = isLocationNoti
            
            if let location = locationManager.location {
                routine.latitude = location.coordinate.latitude
                routine.longitude = location.coordinate.longitude
            }
        } else {
            let newRoutine = Routine(
                title: title,
                content: description,
                date: isCalendarNoti ? date : date,
                isCalendarNoti: isCalendarNoti,
                repeatCycles: selectedRepeat,
                isLocationNoti: isLocationNoti,
                latitude: locationManager.location?.coordinate.latitude,
                longitude: locationManager.location?.coordinate.longitude
            )
            modelContext.insert(newRoutine)
        }
        
        presentationMode.wrappedValue.dismiss()
        print("Saved Your Norou!")
    }
    private func resetLocationData() {
        // 위치 알림이 꺼졌을 때 위치 관련 데이터를 초기화하는 함수
    }
}
#Preview {
    AddNotificationView()
}
