//
//  NoNotificationView.swift
//  Norou
//
//  Created by Cho YeonJi on 6/17/24.
//

import SwiftUI

struct NoNotificationView: View {
    
    var body: some View {
        NavigationView{
            VStack {
                Image(systemName: "bell.slash.fill")
                    .resizable()
                    .frame(width: 85, height: 85)
                    .imageScale(.large)
                
                Text("No pending Notifications")
                    .font(.title2)
                    .bold()
                Group{
                    Text("You currently have no notifications scheduled.")
                    Text("Use the ‘+’ button to add a new notifications.")
                }
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
            }
            .padding()
            .navigationBarItems(
                trailing: NavigationLink(
                    destination: AddNotificationView()){
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                    }
            )
        }
        
    }
    
}

#Preview {
    NoNotificationView()
}
