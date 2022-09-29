//
//  ImageRecordDetail.swift
//  EurekaLab
//
//  Created by Pedro Valderrama on 29/09/2022.
//

import SwiftUI

struct ImageRecordDetail: View {
    
    let record: ImageRecord
    let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var body: some View {
        VStack {
            if let imagePath = record.imagePath,
               let image = UIImage.loadFromDisk(fileName: imagePath) {
                let size = UIScreen.main.bounds.width * 0.8
                Image(uiImage: image)
                    .resizable()
                    .frame(width: size, height: size)
            }
            
            if let id = record.id?.uuidString {
                Text(id)
            }
            
            if let timestamp = record.timestamp {
                Text("Taken: \(timestamp, formatter: itemFormatter)")
            }
            
            if let latitude = record.latitude,
               let longitude = record.longitude {
                Text("Coordinate: \(latitude), \(longitude)")
            }
        }
    }
}
