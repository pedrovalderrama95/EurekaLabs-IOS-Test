//
//  ContentView.swift
//  EurekaLab
//
//  Created by Pedro Valderrama on 28/09/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    @StateObject var viewModel = CameraViewModel()
    @State private var isImagePickerDisplay = false
    
    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.photos, id: \.self) { photo in
                            NavigationLink {
                                Text("Test")
                            } label: {
                                let size = UIScreen.main.bounds.width * 0.3
                                Image(uiImage: photo)
                                    .resizable()
                                    .frame(width: size, height: size)
                            }
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
            }
            .navigationTitle("App Title")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isImagePickerDisplay) {
                ImagePickerView(sourceType: .photoLibrary)
                    .environmentObject(viewModel)
            }
        }
    }
    
    
    //    var body: some View {
    //        NavigationView {
    //            List {
    //                ForEach(items) { item in
    //                    NavigationLink {
    //                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
    //                    } label: {
    //                        Text(item.timestamp!, formatter: itemFormatter)
    //                    }
    //                }
    //                .onDelete(perform: deleteItems)
    //            }
    //            .toolbar {
    //                ToolbarItem {
    //                    Button(action: addItem) {
    //                        Label("Add Item", systemImage: "plus")
    //                    }
    //                }
    //            }
    //            Text("Select an item")
    //        }
    //    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
