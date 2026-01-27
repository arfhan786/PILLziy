//
//  Medication.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import Foundation

struct Medication: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var dosage: String
    var frequency: String
    var labelImageData: Data?
    var createdAt: Date
    
    init(id: UUID = UUID(), name: String, dosage: String, frequency: String, labelImageData: Data? = nil) {
        self.id = id
        self.name = name
        self.dosage = dosage
        self.frequency = frequency
        self.labelImageData = labelImageData
        self.createdAt = Date()
    }
    
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: Medication, rhs: Medication) -> Bool { lhs.id == rhs.id }
}
