//
//  ImageRecordTile.swift
//  EurekaLab
//
//  Created by Pedro Valderrama on 29/09/2022.
//

import SwiftUI

struct ImageRecordTile: View {
    let record: ImageRecord
    
    var body: some View {
        VStack {
            if let imagePath = record.imagePath,
               let image = UIImage.loadFromDisk(fileName: imagePath) {
                let size = UIScreen.main.bounds.width * 0.3
                Image(uiImage: image)
                    .resizable()
                    .frame(width: size, height: size)
            }
        }
    }
}
