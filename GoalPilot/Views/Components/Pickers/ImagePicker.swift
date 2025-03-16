//
//  ImagePicker.swift
//  GoalPilot
//
//  Created by Rune Pollet on 24/08/2024.
//

import SwiftUI
import PhotosUI

/// An application of PHPicker.
struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImageData: Data?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        // Set the configuration so that the user can select 1 image
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        // Create the view controller with this configuration and set our custom coordinator as its delegate
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    // Create the coordinator as the picker's delegate
    class Coordinator: NSObject, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)
            
            // Process the selected photo
            guard let firstResult = results.first else { return }
            let itemProvider = firstResult.itemProvider

            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let selectedImage = image as? UIImage {
                        DispatchQueue.main.async {
                            // Use the selected image
                            self.parent.selectedImageData = selectedImage.pngData()
                        }
                    }
                }
            }
        }

    }
}
