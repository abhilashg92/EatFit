//
//  CameraView.swift
//  EatFit
//
//  Created by Abhilash Ghogale on 27/05/25.
//

import SwiftUI
import UIKit

// MARK: - CameraView
/// A SwiftUI view that presents the camera and returns the captured image.
struct CameraView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                // Debug log for image capture
                print("[DEBUG] CameraView: Image captured.")
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // Debug log for cancel
            print("[DEBUG] CameraView: Image picker cancelled.")
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// MARK: - Preview
struct CameraView_Previews: PreviewProvider {
    @State static var image: UIImage? = nil
    static var previews: some View {
        CameraView(image: $image)
    }
} 