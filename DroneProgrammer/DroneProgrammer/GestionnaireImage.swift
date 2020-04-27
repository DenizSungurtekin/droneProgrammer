//
//  DownloadVC.swift
//  DroneProgrammer
//
//  Created by Mathias Tonini on 08.04.20.
//  Copyright © 2020 CUI. All rights reserved.
//

import Foundation

class GestionnaireImage {
    
    init(){}
    func getImages(){
        do{
            let fileManager = FileManager.default;
            var url = NSHomeDirectory()
            url.append("/Documents/ARSDKMedias")
            
            for photo in try fileManager.contentsOfDirectory(atPath: url){
                if photo != ".DS_Store"{
                    let start_url = URL(fileURLWithPath: url + photo)
                    let imageUI = UIImage(contentsOfFile: start_url.path)
                    UIImageWriteToSavedPhotosAlbum(imageUI!, self, #selector(imageSaved(image:didFinishSavingWithError:contextInfo:)), nil)
                }
                //print(final_url)
                //items.append(final_url)
            }
        }catch{
            print(error)
        }
    }
    @objc func imageSaved(image: UIImage!, didFinishSavingWithError error: NSError?, contextInfo: AnyObject?) {
        if (error != nil) {
            print("error")
            print(error as Any)
            //Do Something with error associated with image
        } else {
            // Everything is alright.
        }
    }
    

}

