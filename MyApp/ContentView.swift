//
//  ContentView.swift
//  MyApp
//
//  Created by Deepak Bhat on 27/07/23.
//

import SwiftUI
//import Alamofire

struct ContentView: View {
    @State private var showingForm = false
    let myGrayColor : Color = Color(red: 0.651, green: 0.651, blue: 0.651)
    let myBlackColor : Color = Color(red: 0, green: 0, blue: 0)

    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                ZStack {
                    Image("wave")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                
                    

                
                    VStack {
                        Spacer()
                        Text("MyApp")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(myBlackColor.opacity(0.4))
                            .cornerRadius(15)
                        
                        Spacer()
                        
                        NavigationLink {
                            ExpiryTrackerView()
                        } label: {
                            Text("Expiry Tracker")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding()
                                .background(myBlackColor.opacity(0.4))
                                .cornerRadius(15)
                        }
                    
                        NavigationLink {
                            FormView()
                        } label: {
                            Text("Grocery Inventory")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding()
                                .background(myBlackColor.opacity(0.4))
                                .cornerRadius(15)
                        }
                        
                        NavigationLink {
                            FormView()
                        } label: {
                            Text("Daily Tasks")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding()
                                .background(myBlackColor.opacity(0.4))
                                .cornerRadius(15)
                        }
                        Spacer()
                        Spacer()
                    }.padding()
                }
            }
        }
    }
}

struct FormView: View {
    @State private var name: String = ""
    @State private var email: String = ""

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
            VStack {
                Text("Grocery Inventory")
                    .foregroundColor(Color.white)

                Form {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                    Button(action: {
                        // Action to perform when Submit button is tapped
                        print("Submit button tapped")
                        //                sendDataToGoogleSheets()
                    }) {
                        Text("Submit")
                    }
                }
                .background(Color.clear)
            }
        }
    }
}

//func sendDataToGoogleSheets(name: String, email: String) {
//    // API endpoint URL
//    let url = "https://sheets.googleapis.com/v4/spreadsheets/YOUR_SPREADSHEET_ID/values/Sheet1?key=YOUR_API_KEY"
//
//    // Form data
//    let parameters: [String: Any] = [
//        "range": "A2:B2", // The cell range where you want to write the data
//        "majorDimension": "ROWS",
//        "values": [
//            [name, email]
//        ]
//    ]
//
//    // Make the POST request
//    AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
//        switch response.result {
//        case .success:
//            print("Data sent to Google Sheets successfully!")
//        case .failure(let error):
//            print("Error sending data to Google Sheets: \(error)")
//        }
//    }
//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
