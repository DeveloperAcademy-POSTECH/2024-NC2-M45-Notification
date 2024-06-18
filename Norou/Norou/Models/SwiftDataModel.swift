//
//  SwiftDataModel.swift
//  Norou
//
//  Created by 김도현 on 6/19/24.
//

import Foundation
import SwiftData

@Model
class Routine: Identifiable {
    let id: UUID
    var createDate: Date
    var title: String?
    var content: String?
    var date: Date?
    var isCalendarNoti: Bool
    var repeatCycles: String?
    var isLocationNoti: Bool
    var latitude: Double?
    var longitude: Double?
    
    init(id: UUID = UUID(), createDate: Date = Date(), title: String? = nil, content: String? = nil, date: Date? = nil, isCalendarNoti: Bool, repeatCycles: String? = nil, isLocationNoti: Bool, latitude: Double? = nil, longitude: Double? = nil) {
        self.id = id
        self.createDate = createDate
        self.title = title
        self.content = content
        self.date = date
        self.isCalendarNoti = isCalendarNoti
        self.repeatCycles = repeatCycles
        self.isLocationNoti = isLocationNoti
        self.latitude = latitude
        self.longitude = longitude
    }
}

