//
//  NotificationListView.swift
//  Norou
//
//  Created by 김도현 on 6/17/24.
//

import SwiftUI
import SwiftData

struct NotificationListView: View {
    @Query(sort: \Routine.createDate, order: .forward) private var routines: [Routine]
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        if routines.isEmpty {
            NoNotificationView()
        } else {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: [GridItem()], spacing: 20) {
                        ForEach(routines) { routine in
                            NavigationLink(destination: AddNotificationView(routine: routine)) {
                                VStack(alignment: .leading) {
                                    Text(routine.title ?? "No Title")
                                        .font(.headline)
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(routine.content ?? "No Content")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding()
                                .background(Color(UIColor.systemBackground))
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(20)
                .background(Color(UIColor.secondarySystemBackground))
                .navigationTitle("Routines")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    trailing: NavigationLink(
                        destination: AddNotificationView()){
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(5)
                        }
                )
            }
        }
    }
}

#Preview {
    NotificationListView()
}






