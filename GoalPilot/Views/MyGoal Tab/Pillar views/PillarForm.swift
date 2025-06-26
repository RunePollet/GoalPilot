//
//  PillarForm.swift
//  GoalPilot
//
//  Created by Rune Pollet on 12/08/2024.
//

import SwiftUI

/// A form containing all data of a pillar.
struct PillarForm: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var pillar: Pillar
    var isEditing: Bool
    var isCreating: Bool
    
    @State private var showRemoveAlert = false
    @State private var showImagePicker = false
    @State private var icons: [String: [String]] = ["Default":["flag.square"]]
    
    var body: some View {
        Form {
            // Title and description
            Section {
                NavigationLink(value: TextPropertyEditor<Pillar>.Model(root: pillar, keyPath: \.title, title: "Title")) {
                    LabeledContent("Title", value: pillar.title)
                }
                NavigationLink(value: TextPropertyEditor<Pillar>.Model(root: pillar, keyPath: \.info.boundString, title: "Description", axis: .vertical)) {
                    LabeledContent {
                        Text(pillar.info ?? "")
                            .lineLimit(nil)
                    } label: {
                        Text("Description")
                    }
                }
            }
            .labeledContentStyle(.plain)
            .foregroundStyle(.primary, Color.accentColor)
            
            // Image or icon
            Section {
                Group {
                    if let imageData = pillar.imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(height: 70)
                    } else {
                        Text("Image")
                    }
                }
                .drillIn {
                    showImagePicker = true
                }
                Menu {
                    iconPicker
                } label: {
                    HStack {
                        Text("Icon")
                        Spacer()
                        Image(systemName: pillar.icon)
                            .foregroundStyle(.secondary)
                        Image(systemName: "chevron.up.chevron.down")
                            .foregroundStyle(Color.accentColor)
                    }
                }
                .buttonStyle(.tappable)
            } footer: {
                Text("Add an image or choose an icon to represent this pillar. The icon will only show if there is no image.")
                    .foregroundStyle(Color.secondary)
            }
            
            // Remove button
            if isEditing && !isCreating {
                Button("Remove", role: .destructive) {
                    showRemoveAlert = true
                }
                .frame(maxWidth: .infinity)
            }
        }
        .alert("Are your sure?", isPresented: $showRemoveAlert) {
            Button("Cancel", role: .cancel) {}
            
            Button("Remove", role: .destructive) {
                pillar.delete(from: modelContext)
                dismiss()
            }
        } message: {
            Text("Are you sure this pillar isn't a part of your dream anymore? You won't be able to recover it after removal.")
        }
        .navigationDestination(for: TextPropertyEditor<Pillar>.Model.self) { model in
            TextPropertyEditor(model: model)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImageData: $pillar.imageData)
        }
        .task {
            let symbols = await getSFSymbols()
            await MainActor.run {
                self.icons = symbols
            }
        }
    }
    
    private var iconPicker: some View {
        ForEach(icons.keys.sorted(), id: \.self) { key in
            Picker(key, selection: $pillar.icon) {
                if let icons = icons[key] {
                    ForEach(icons, id: \.self) { symbol in
                        Image(systemName: symbol)
                    }
                }
            }
            .pickerStyle(.menu)
        }
    }
    
    private func getSFSymbols() async -> [String: [String]] {
        guard let url = Bundle.main.url(forResource: "Symbols", withExtension: "json") else { return [:] }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let results = try decoder.decode([String: [String]].self, from: data)
            return results
        }
        catch {
            print("Error fetching or decoding symbols: \(error)")
            return [:]
        }
    }
}

