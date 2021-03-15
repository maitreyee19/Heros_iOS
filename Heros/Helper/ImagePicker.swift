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
    @Binding var faceBBox : CGRect
    
    
    
    init(image: Binding<UIImage> , showModal:Binding<Bool> , prediction :Binding<String> , faceBBox : Binding<CGRect>) {
        _image = image
        _showModal = showModal
        _prediction = prediction
        _faceBBox = faceBBox
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            image = uiImage
            showModal = false
            print("New Image picked, Lets call the service to get the character detail")
            faceDetaction(image: CIImage(image: image)!)
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
    
    /**
     face dection request
     */
    func faceDetaction(image: CIImage) {
        
        print("Finding the face...")
        let config = MLModelConfiguration()
        config.computeUnits = .all
        
        let faceDetectionReqeust = VNDetectFaceRectanglesRequest(){ (vnrequest, error) in
            if let results = vnrequest.results as? [VNFaceObservation] {
                DispatchQueue.main.async {
                    for observation in results{
                        self.faceBBox = observation.boundingBox
                        self.faceBBox.origin.x *= 120
                        self.faceBBox.origin.y = (1-self.faceBBox.origin.y) * 100
                        self.faceBBox.size.width *= 120
                        self.faceBBox.size.height *= -100
                        print(self.faceBBox)
                    }
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([faceDetectionReqeust])
            } catch {
                print("Err :( \(error)")
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
    @Binding var faceBBox:CGRect
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController();
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(image: $image , showModal:$showModal , prediction: $prediction , faceBBox: $faceBBox)
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

