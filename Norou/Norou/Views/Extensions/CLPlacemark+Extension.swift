//
//  CLPlacemark+Extension.swift
//  Norou
//
//  Created by Cho YeonJi on 6/20/24.
//

import Foundation

// CLPlacemark의 주소를 포맷하는 확장
extension CLPlacemark {
    var formattedAddress: String {
        var address = ""
        
        if let administrativeArea = administrativeArea {
            address += "\(administrativeArea) "
        }
        
        if let locality = locality {
            address += "\(locality) "
        }
        
        if let thoroughfare = thoroughfare {
            address += "\(thoroughfare) "
        }
        
        if let subThoroughfare = subThoroughfare {
            address += "\(subThoroughfare) "
        }
        
        if let name = name {
            address += "\(name)"
        }
        
        return address.isEmpty ? "주소를 찾을 수 없음" : address
    }
}
