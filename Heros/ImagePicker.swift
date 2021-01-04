//
//  ImagePicker.swift
//  Heros
//
//  Created by bhabani das on 1/3/21.
//

import Foundation
import SwiftUI

class ImagePickerCoordinator: NSObject , UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    
    @Binding var image : UIImage
    @Binding var showModal : Bool
    
    init(image: Binding<UIImage> , showModal:Binding<Bool>) {
        _image = image
        _showModal = showModal
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            image = uiImage
            showModal = false
            print("New Image picked, Lets call the service to get the character detail")
        }
        
    }
    
}

struct ImagePicker:UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @Binding var image:UIImage
    var sourceType: UIImagePickerController.SourceType = .camera
    @Binding var showModal:Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController();
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(image: $image , showModal:$showModal)
    }
    
    
}
