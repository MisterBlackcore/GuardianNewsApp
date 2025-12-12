//
//  Array.swift
//  GuardianNewsApp
//
//  Created by Interexy on 9.12.25.
//

import UIKit

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map { start in
            Array(self[start..<Swift.min(start + size, count)])
        }
    }
}
