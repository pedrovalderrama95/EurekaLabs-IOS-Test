//
//  ViewModel.swift
//  EurekaLab
//
//  Created by Pedro Valderrama on 28/09/2022.
//

import SwiftUI
import CoreLocation
import CoreData

class ViewModel: NSObject, ObservableObject {
    @Published var authorizationStatus: CLAuthorizationStatus
    private var location: CLLocationCoordinate2D?
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
}

extension ViewModel: CLLocationManagerDelegate {
    func requestLocation() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}

extension ViewModel {
    
    func addItem(viewContext: NSManagedObjectContext, image: UIImage?) {
        withAnimation {
            let id = UUID()
            let newItem = ImageRecord(context: viewContext)
            newItem.id = id
            newItem.timestamp = Date()
            newItem.longitude = location?.longitude ?? 0
            newItem.latitude = location?.latitude ?? 0
            newItem.imagePath = image?.saveInDisk(imageName: id.uuidString)
            
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    func deleteItems(viewContext:  NSManagedObjectContext, items: FetchedResults<ImageRecord>, offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    }
    
}
