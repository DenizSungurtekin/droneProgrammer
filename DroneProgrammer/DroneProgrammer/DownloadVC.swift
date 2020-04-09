//
//  DownloadVC.swift
//  DroneProgrammer
//
//  Created by Mathias Tonini on 08.04.20.
//  Copyright © 2020 CUI. All rights reserved.
//

import Foundation
class collectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}
class DownloadVC:UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    let reuseIdentifier = "cell"
    var items: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func getImages(){
        do{
            let fileManager = FileManager.default;
            var url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false);
            let media = "/ARSDKMedias"

            url = url.appendingPathComponent(media);
            let StringURL = try url.absoluteString;
            
            for photo in try fileManager.subpathsOfDirectory(atPath: StringURL){
                items.append(StringURL + photo)
            }
        }catch{
            print(error)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! collectionCell
        
        let image = items[indexPath.row]
        cell.imageView.image = UIImage(named: image)
        return cell
    }

}

