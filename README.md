# 2024-NC2-M0-AugmentedReality
## 🎥 Youtube Link
[(유튜브 링크 바로가기)](https://youtu.be/80vlJmtogyk?si=qUd_vcIbNQfgKCCz)
<br/>

## 💡 About Augmented Reality
- 앱이 백그라운드에서 실행 중이든 비활성 상태이든 사람들에게 각 시기에 적절하고 관련성 있는 정보를 한 눈에 알아볼 수 있는 짧은 컨텐츠(정보)를 제공하는 역할을 합니다.
- Notification은 메시지를 표시하거나, 독특한 소리를 재생하거나, 앱 아이콘의 배지(Badge)를 업데이트할 수 있습니다
- Notification을 사용하기 위해서는 먼저 알림 권한을 승인 받아야합니다.
- 원하는 오디오, 이미지, 영상을 Notification에 넣을 수 있습니다.
- Notification에는 여러가지 trigger가 있습니다.
   - UNPushNotificationTrigger를 이용해 Romote Notification을 만들 수 있습니다.
   - UNCalendarNotificationTrigger를 이용하면 특정 날짜와 시간에 Notification을 받을 수 있습니다.
   - UNTimeIntervalNotificationTrigger를 이용하면 특정 시간이 시간이 지나면 Notification을 받을 수 있습니다.
   - UNLocationNotificationTrigger를 이용하면 특정 장소에 도착하거나, 특정 장소를 떠나면 Notification을 받을 수 있습니다.
<br/>

## 🎯 What we focus on?
- UserNotifications의 다양한 Trigger들을 활용하여, 사용자가 원하는 날짜/시간/장소 입장 또는 퇴장 시 알림을 받을 수 있게 한다.
<br/>

## 💼 Use Case
애플 디벨로퍼 아카데미 러너의 루틴을 Notification을 통해 관리할 수 있게 하자
<br/>
<br/>

## 🖼️ Prototype
![12345](https://github.com/DeveloperAcademy-POSTECH/2024-NC2-M45-Notification/assets/116636498/f094ffd7-1aed-4ae4-a036-2e3f14ebded4)
<br/>
<br/>

## 🛠️ About Code <br/>
- Notification 권환 요청

```swift
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
```
<br/>

- Notification의 content와 trigger 설정

```swift
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
        
        if isLocationNoti {
            if let latitude = locationManager.location?.coordinate.latitude, let longitude = locationManager.location?.coordinate.longitude {
                let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let region = CLCircularRegion(center: center, radius: 100, identifier: UUID().uuidString)
                region.notifyOnEntry = true
                region.notifyOnExit = false
                
                trigger = UNLocationNotificationTrigger(region: region, repeats: false)
            } else {
                print("위치 정보를 가져오지 못함")
            }
        }
```
<br/>

- Notification 생성

```swift
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
```
