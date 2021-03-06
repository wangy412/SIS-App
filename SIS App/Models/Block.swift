//
//  Block.swift
//  SIS App
//
//  Created by Wang Yunze on 3/11/20.
//

import CoreLocation
import Foundation

struct Block: CheckInTarget {
    let name: String
    var id: String { name }

    /// The short name, used when space is scarce, e.g. widgets
    /// This basically just strips the "Block" from the back where applicable
    var shortName: String {
        let suffix = " Block"
        guard name.hasSuffix(suffix) else { return name } // E.g. ARTSpace
        return String(name.dropLast(suffix.count))
    }

    var location: Location
    var radius: Double

    @RawKeyedCodableDictionary var categories: [RoomCategory: [Room]]

    init(name: String, location: Location, radius: Double, categories: [RoomCategory: [Room]]) {
        self.name = name
        self.location = location
        self.radius = radius
        self.categories = categories
    }

    init(_ name: String) {
        self.name = name
        location = Location(longitude: 0, latitude: 0)
        radius = 1
        categories = [RoomCategory: [Room]]()
    }
}
