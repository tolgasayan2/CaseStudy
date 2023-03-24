//
//  Array+Extension.swift
//  CaseStudy
//
//  Created by Tolga Sayan on 24.03.2023.
//

import Foundation

public extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}
