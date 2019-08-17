//
//  PhotosCollectionViewController.swift
//  GroceryList
//
//  Created by Omer Cohen on 8/2/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//


import Foundation
import UIKit
import Photos
import RxSwift
import Firebase

class PhotosCollectionViewController: UICollectionViewController {
    
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    private let selectedPathImage = PublishSubject<String>()
    let storage = Storage.storage(url:"gs://grocerylist-5c6ee.appspot.com")

    var modelCell: ModelCell?
    var name: String = ""
    var pathString: String = ""

    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }
    
    var selectedPath: Observable<String> {
        return selectedPathImage.asObservable()
    }
    
    private var images = [PHAsset]()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populatePhotos()
        setNavigationTopBar()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedAsset = self.images[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { [weak self] image, info in
            
            guard let info = info else { return }
            
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
            
            if !isDegradedImage {
                
                selectedAsset.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (eidtingInput, info) in
                    if let input = eidtingInput, let imgURL = input.fullSizeImageURL {
                        let path:String = imgURL.description
                        print("path",path)
                        self?.selectedPathImage.onNext(path)
                    }
                }
                if let image = image {
                    if let name = self?.name, let path = self?.pathString {
                        self?.addImgToFireStorge(pathString: path, image: image, itemName: name)
                        self?.selectedPhotoSubject.onNext(image)
                        self?.dismiss(animated: true, completion: nil)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("PhotoCollectionViewCell is not found")
        }
        
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
        
        manager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: nil) { image, _ in
            
            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
            
        }
        
        return cell
        
    }
    
    private func populatePhotos() {
        
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                
                // access the photos from photo library
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                
                assets.enumerateObjects { (object, count, stop) in
                    self?.images.append(object)
                }
                
                self?.images.reverse()
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    func setNavigationTopBar() {
        navigationItem.title = "Pick Up Photo"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:  UIImage(named: "icons8-circled-x-50.png"), style: .plain, target: self, action: nil)
        
        if let rightBtn = navigationItem.rightBarButtonItem {
            rightBtn.rx.tap.subscribe{ _ in
                self.dismiss(animated: true, completion: nil)
                
                }.disposed(by: disposeBag)
        }
    }
    
    func addImgToFireStorge(pathString: String,  image: UIImage, itemName: String) {
        
        let storageRef = storage.reference()
        storageRef.child(pathString)
        // Data in memory
        if let data = image.pngData() {
            // Create a reference to the file you want to upload
            let riversRef = storageRef.child("\(pathString)/images/\(itemName).jpg")
            
            // Upload the file to the path "images/rivers.jpg"
            let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                riversRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                }
            }
        }
    }

}
