//
//  ImagePicker.swift
//  Heros
//
//  Created by bhabani das on 1/3/21.
//

import Foundation
import SwiftUI
import Vision

class ImagePickerCoordinator: NSObject , UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    
    @Binding var image : UIImage
    @Binding var showModal : Bool
    @Binding var prediction : String
    
    init(image: Binding<UIImage> , showModal:Binding<Bool> , prediction :Binding<String>) {
        _image = image
        _showModal = showModal
        _prediction = prediction
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            image = uiImage
            showModal = false
            print("New Image picked, Lets call the service to get the character detail")
            let config = MLModelConfiguration()
            config.computeUnits = .all
            do{
                let heroModel = try PrincessClassfier_v1(configuration: config)
                if let pixelBuffer = image.toCVPixelBuffer(){
                    let heroPrediction = try heroModel.prediction(image: pixelBuffer)
                    self.prediction = heroPrediction.classLabel
                    print(" Predicted hero is \(self.prediction)")
                    
                }
            }catch{
                self.prediction = "Elsa"
                print(error)
            }
            
        }
    }

}

struct ImagePicker:UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @Binding var image:UIImage
    var sourceType: UIImagePickerController.SourceType = .camera
    @Binding var showModal:Bool
    @Binding var prediction:String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController();
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(image: $image , showModal:$showModal , prediction: $prediction)
    }
}



func resizeImage(inputImage : UIImage) -> UIImage?{
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 299), true, 2.0)
    inputImage.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
    var pixelBuffer : CVPixelBuffer?
    let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
    guard (status == kCVReturnSuccess) else {
        return nil
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
    let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
    
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
    
    context?.translateBy(x: 0, y: newImage.size.height)
    context?.scaleBy(x: 1.0, y: -1.0)
    
    UIGraphicsPushContext(context!)
    newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
    UIGraphicsPopContext()
    CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
    
    return newImage
}


func recognizeImage(image: CIImage) {
    
    print("I'm investigating...")
    print(image)
    let config = MLModelConfiguration()
    config.computeUnits = .all
    if let model = try? VNCoreMLModel(for: HeroClassifier_1(configuration: config).model) {
        
        let request = VNCoreMLRequest(model: model) { (vnrequest, error) in
            
            if let results = vnrequest.results as? [VNClassificationObservation] {
                print("Going to process results")
                let topResult = results.first
                DispatchQueue.main.async {
                    let confidenceRate = (topResult?.confidence)! * 100
                    let rounded = Int (confidenceRate * 100) / 100
                    print("\(rounded)% it's \(topResult?.identifier ?? "Anonymous")")
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print("Err :( \(error)")
            }
        }
    }
}



import UIKit

extension UIImage {
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else {
            return nil
        }
        
        if let pixelBuffer = pixelBuffer {
            CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
            
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
            
            context?.translateBy(x: 0, y: self.size.height)
            context?.scaleBy(x: 1.0, y: -1.0)
            
            UIGraphicsPushContext(context!)
            self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            UIGraphicsPopContext()
            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            
            return pixelBuffer
        }
        
        return nil
    }
}
