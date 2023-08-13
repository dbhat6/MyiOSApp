//
//  ExpiryDataStore.swift
//  MyApp
//
//  Created by Deepak Bhat on 07/08/23.
//

import Foundation

class ExpiryDataStore: ObservableObject {
    @Published var expiryItems: [ExpiryItem] = []
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("expiryTracker.data")
    }
    
    func load() async throws {
        let task = Task<[ExpiryItem], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let dailyScrums = try JSONDecoder().decode([ExpiryItem].self, from: data)
            print(dailyScrums)
            return dailyScrums
        }
        let expiries = try await task.value
        self.expiryItems = expiries
    }
    
    func save(items: [ExpiryItem]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(items)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
}
