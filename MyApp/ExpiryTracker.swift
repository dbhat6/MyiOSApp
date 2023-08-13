//
//  ExpiryTracker.swift
//  MyApp
//
//  Created by Deepak Bhat on 06/08/23.
//

import Foundation
import SwiftUI
import UserNotifications

struct ExpiryTrackerView: View {
    @StateObject private var store = ExpiryDataStore()
    @State private var items = [ExpiryItem]()
    @State private var showingForm = false
    
    var body: some View {
        NavigationView {
            VStack {
                List(items) { item in
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text("Expiry Date: \(item.expiryDate, formatter: itemFormatter)")
                            .foregroundColor(item.isExpired ? .red : .secondary)
                    }
                }
                
                Button("Add Item") {
//                    addItem()
                    self.showingForm.toggle()
                }
                if showingForm {
                    AddExpiryView(onSubmit: addItem)
                }
            }
            .navigationBarTitle("Expiry Tracker")
            .onAppear(perform: {
                fetchItems()
            })
        }
    }
    
    func fetchItems() {
        async {
            do {
                try await store.load()
            } catch {
                print("Error fetching expiry items: \(error)")
            }
        }
    }
    
    func addItem(name: String, expiryDate: Date) async {
        let newItem = ExpiryItem(name: name, expiryDate: expiryDate) // Replace this with the actual expiry date of the item
        items.append(newItem)
        
        // Schedule a notification for the expiry date
        checkForPermission(for: newItem)
        do {
            try await store.save(items: items)
        } catch {
            print("Caught an error here \(error)")
        }
        
    }
    
    func checkForPermission(for item: ExpiryItem) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.scheduleNotification(for: item)
            case .denied:
                return
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.scheduleNotification(for: item)
                    }
                }
            default:
                return
            }
        }
    }
    
    
    private func scheduleNotification(for item: ExpiryItem) {
        let content = UNMutableNotificationContent()
        content.title = "Item Expiry Alert"
        content.body = "\(item.name) has expired!"
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: item.expiryDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

private struct AddExpiryView: View {
    @State private var name: String = ""
    @State private var date: Date = Date()
    let onSubmit: (String, Date) -> Void
    let structInstance = ExpiryTrackerView()

    var body: some View {
        Form {
            TextField("Name", text: $name)
            DatePicker(
                    "Expiry Date",
                    selection: $date,
                    displayedComponents: [.date, .hourAndMinute]
                )

            Button(action: {
                // Action to perform when Submit button is tapped
                print("Submit button tapped")
                print("Name: \(name)")
                print("Date: \(date)")
                onSubmit(name, date)
                //                sendDataToGoogleSheets()
            }) {
                Text("Submit")
            }
        }
    }
}



struct ExpiryTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        ExpiryTrackerView()
    }
}



struct ExpiryItem: Identifiable, Encodable, Decodable {
    let id = UUID()
    let name: String
    let expiryDate: Date
    
    var isExpired: Bool {
        return expiryDate < Date()
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()
