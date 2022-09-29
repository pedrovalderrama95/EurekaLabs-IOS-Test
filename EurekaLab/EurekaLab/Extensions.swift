//
//  Extensions.swift
//  EurekaLab
//
//  Created by Pedro Valderrama on 29/09/2022.
//

import Foundation
import UIKit

extension UIImage {
    func saveInDisk(imageName: String) -> String? {
        guard let data = self.jpegData(compressionQuality: 1),
              let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                print(error)
            }
            
        }
        
        do {
            try data.write(to: fileURL)
            return imageName
        } catch {
            print(error)
            return nil
        }
    }
    
    static func loadFromDisk(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
        }
        
        return nil
    }
}
