//
//  ContentView.swift
//  EurekaLab
//
//  Created by Pedro Valderrama on 28/09/2022.
//

import SwiftUI
import CoreData
import CoreLocation

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ImageRecord.timestamp, ascending: true)],
        animation: .default)
    var items: FetchedResults<ImageRecord>
    
    @StateObject private var viewModel = ViewModel()
    @State private var isImagePickerDisplay = false
    
    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(items, id: \.id) { imageRecord in
                            NavigationLink {
                                ImageRecordDetail(record: imageRecord)
                            } label: {
                                ImageRecordTile(record: imageRecord)
                            }
                        }
                        .onDelete {
                            viewModel.deleteItems(viewContext: viewContext,
                                                  items: items,
                                                  offsets: $0)
                        }
                    }
                }
                .padding(.horizontal, 10)
                Spacer()
                Button(action: {
                    isImagePickerDisplay.toggle()
                }) {
                    Text("Take Picture")
                        .padding(.all, 10)
                        .foregroundColor(.white)
                }.background(.blue)
                    .cornerRadius(6)
                    .padding(.bottom, 20.0)
                LocationStatus()
                    .environmentObject(viewModel)
            }
            .navigationTitle("EurekaLab Test")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isImagePickerDisplay) {
                ImagePickerView(sourceType: .camera)
                    .environmentObject(viewModel)
            }
            .onAppear {
                viewModel.requestLocation()
            }
        }
    }
    
}

struct LocationStatus: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        switch viewModel.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            Text("Location permissions authorized")
        default:
            Text("The app does not have location permissions. Please enable them in settings.")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
