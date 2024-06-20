//
//  LocationManager.swift
//  Norou
//
//  Created by Cho YeonJi on 6/19/24.
//


//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    let manager = CLLocationManager()
//
//    @Published var location: CLLocationCoordinate2D?
//
//    override init() {
//        super.init()
//        manager.delegate = self
//    }
//
//    func requestLocation() {
//        manager.requestLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        location = locations.first?.coordinate
//        print(locations.first?.coordinate)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
//        print(error)
//    }
//
//
//}

import Foundation
import CoreLocation
import CoreLocationUI
// LocationManager 클래스 정의
// LocationManager 클래스 정의
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var placemark: CLPlacemark? // 추가: 주소 정보 저장
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        checkAuthorizationStatus()
    }
    
    func requestLocation() {
        if CLLocationManager.locationServicesEnabled() {
            DispatchQueue.main.async {
                self.locationManager.requestLocation()
            }
        } else {
            print("위치 서비스가 비활성화되어 있습니다.")
        }
    }
    
    func checkAuthorizationStatus() {
        authorizationStatus = locationManager.authorizationStatus
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func reverseGeocodeLocation() {
        if let location = self.location {
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Reverse geocode 실패: \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?.first {
                    DispatchQueue.main.async {
                        self.placemark = placemark
                    }
                } else {
                    print("주소를 찾을 수 없음")
                }
            }
        } else {
            print("위치 정보가 없음")
        }
    }
    
    // CLLocationManagerDelegate 메서드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
            reverseGeocodeLocation() // 위치가 업데이트되면 주소 역으로 변환
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 업데이트 오류: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            requestLocation()
        } else if authorizationStatus == .denied {
            print("위치 권한이 거부되었습니다.")
        }
    }
}
