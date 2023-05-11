//
//  ViewController.swift
//  Instagram
//
//  Created by Akshay Yendhe on 16/02/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var galleryCollection: UICollectionView!
    var galleryArray = [GalleryData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        // Do any additional setup after loading the view.
    }
    func fetchData(){
        let url = URL(string: "https://api.unsplash.com/photos/?client_id=nyLCTvFK3GU9pyT9bU784NDsXSevO0V2Lf5oGDHetzk")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data,response,error) in
            guard let data = data , error == nil else{
                return
            }
            do{
                let obj = try JSONSerialization.jsonObject(with: data)
                guard let dictArray = obj as? [[AnyHashable: Any]]
                else{
                    return
                }
                for dict in dictArray{
                    let id = dict["id"] as! String
                    let createdDate = dict["created_at"] as! String
                    let description = dict["alt_description"] as! String
                    let urlsDict = dict["urls"] as! [AnyHashable:Any]
                    let smallurl = urlsDict["small"] as! String
                    let fullurl = urlsDict["full"] as! String
                    let userDict = dict["user"] as! [AnyHashable:Any]
                    let name = userDict["name"] as! String
                    let like = dict["likes"] as! Int
                    
                    let galleryItem = GalleryData(id: id, createdDate: createdDate, description: description, smallUrl: smallurl, fullUrl: fullurl, likes: like, name: name)
                    self.galleryArray.append(galleryItem)
                }
                DispatchQueue.main.async {
                    self.galleryCollection.reloadData()
                }
            }
            catch{
                print("error occured")
            }
        })
        task.resume()
        
    }
    
}
extension UIImageView{
    func downloadsThumbnails(url:URL){
        contentMode = .scaleToFill
        let imageTask = URLSession.shared.dataTask(with: url, completionHandler: {
            (data,response,error) in
            guard let httpURLres = response as? HTTPURLResponse, httpURLres.statusCode == 200,
                  let imageType = response?.mimeType, imageType.hasPrefix("image"),
                  let data = data, error == nil,
                  let image = UIImage(data: data)
            else{
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        })
        imageTask.resume()
    }
}
extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCollectionViewCell
        let imageData = galleryArray[indexPath.row]
        let url = URL(string: imageData.smallUrl)!
        cell.imageView.downloadsThumbnails(url: url)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        let collctionHeight = collectionView.bounds.height
        return CGSize(width: collectionWidth/2, height: collectionWidth/2)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageItem = galleryArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
        vc.imageItem = galleryArray
        vc.imageIndex = indexPath
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
