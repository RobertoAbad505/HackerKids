//
//  Image+Conversions.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/2/25.
//

import SwiftUI

extension Data {
    func createImage() -> Image? {
        let value = self
        guard let uiImage: UIImage = UIImage(data: value) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
}
