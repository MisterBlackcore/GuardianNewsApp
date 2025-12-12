//
//  Image.swift
//  GuardianNewsApp
//
//  Created by Interexy on 10.12.25.
//

import SwiftUI

extension Image {
    init(_ appImage: AppImageService) {
        self.init(appImage.rawValue)
    }
}
