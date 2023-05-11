//
//  PhotoViewController.swift
//  Instagram
//
//  Created by Akshay Yendhe on 16/02/23.
//

import UIKit

class PhotoViewController: UIViewController , UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var imageItem = [GalleryData]()
    var imageIndex : IndexPath?
    
    @IBOutlet weak var photoCollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.photoCollection.reloadData()
        photoCollection.scrollToItem(at: imageIndex!, at: .left, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecell", for: indexPath) as! PhotoCollectionViewCell
        let obj = imageItem[indexPath.row]
        cell.name.text = "Name : \(obj.name)"
        cell.createDate.text = "CreatedDate : \(obj.createdDate)"
        cell.likesUILabel.text = "Likes: \(obj.likes)"
        cell.infoUILabel.text = "Description : \(obj.description)"
        let url = URL(string: obj.fullUrl)!
        cell.photo.downloadsThumbnails(url: url)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
