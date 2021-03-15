//
//  CameraView.swift
//  Heros
//
//  Created by bhabani das on 1/3/21.
//

import SwiftUI

struct CameraView: View {
    @State private var showSheet:Bool = false
    @State private var showImagePicker = false
    @State private var charactorName = ""
    //    @State private var image:UIImage  = UIImage(systemName:"camera.on.rectangle")!
    @State private var image:UIImage  = UIImage(imageLiteralResourceName: "Camera")
    @State private var sourceType :UIImagePickerController.SourceType = .camera
    @State private var overlayRect = CGRect(x: 0, y: 0, width: 100, height: 100)
    
     
    var body: some View {
        
        HStack{
            Button(action:{
                self.showSheet = true
            }){
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10) {
                    HStack{
                        Image(uiImage: image)
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 120, height: 100)
                            .cornerRadius(5)
                            .overlay(Rectangle()
                                        .path( in : overlayRect)
                                        .stroke(Color.red , lineWidth: 2)
                            )
                    }
                    Text("Select Picture")
                }
            }
            .actionSheet(isPresented: $showSheet, content:{
                            ActionSheet(title: Text("Select Photo"),
                                        message: Text("Choose"),
                                        buttons: [
                                            .default(Text("Photo Library")){
                                                self.showImagePicker = true
                                                self.sourceType = .photoLibrary
                                            },
                                            .default(Text("Camera")){
                                                self.showImagePicker = true
                                                self.sourceType = .camera
                                            },
                                            .cancel()])}
            )
            .sheet(isPresented: $showImagePicker, content: {
                ImagePicker(image: self.$image, sourceType: self.sourceType , showModal: self.$showImagePicker , prediction: $charactorName , faceBBox: $overlayRect)
            })
            
            if(charactorName != ""){
                SelectedItem(heroName: self.charactorName)
            }
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        return CameraView()
    }
}
