//
//  OverlayImageVC.swift
//  CheckImageColor
//
//  Created by Ramkumar J on 30/07/22.
//

import UIKit

class imageCollection: UICollectionViewCell{
    @IBOutlet weak var collImg: UIImageView!
    
}

class OverlayImageVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var droppedView: DashedLineView!
    
   var imageView: UIImageView = UIImageView()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath)
        cell.tag = indexPath.row
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(touched(_:)))
        cell.addGestureRecognizer(gestureRecognizer)
        return cell
    }
    
    @objc private func touched(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if let touchedView = gestureRecognizer.view {
            if gestureRecognizer.state == .began {
//                        initialMovableViewPosition = touchedView.frame.origin
                let frame = imageCollection.convert(touchedView.frame, to: self.view)
                print("coll=",self.imageCollection.frame.origin.y)
                print("view=",self.view.frame.size.height)
                imageView.frame = frame
                imageView.image = UIImage.init(named: "tagImage")
                imageView.alpha = 0.5
                self.view.bringSubviewToFront(imageView)
                self.view.addSubview(imageView)
                print(frame.origin.y)
                }
               else if gestureRecognizer.state == .changed {
                   let locationInView = gestureRecognizer.location(in: touchedView)
                   
                   //let locationInView = gestureRecognizer.translation(in: imageCollection)
                   
                   let frameOne = imageCollection.convert(locationInView, to: self.view)
                   
                   //let frame = imageCollection.convert(touchedView.frame, to: self.view)
                   imageView.center = CGPoint(x:frameOne.x + touchedView.frame.origin.x, y: frameOne.y)
                  // imageView.center = frame.origin
               }else if gestureRecognizer.state == .ended{
                   if (imageView.frame.intersects(droppedView.frame)) {
                       
                       
                   }else{
                       imageView.removeFromSuperview()
                       
                   }
               }
            }
       
    }
    
    @IBOutlet weak var overlayImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let img = self.overlayImageaction()
        overlayImg.image = img
        // Do any additional setup after loading the view.
        UIImageWriteToSavedPhotosAlbum(img, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
        @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if let error = error {
                // we got back an error!
                print("Saved Not")
            } else {
                print("Saved Not")
            }
        }
    
    func overlayImageaction() -> UIImage {
        var bottomImage = UIImage(named: "imageOne")
        var topImage = UIImage(named: "tagImage")

        var size = CGSize(width: 300, height: 300)
        UIGraphicsBeginImageContext(size)

        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let areaSize1 = CGRect(x: 118, y: 118, width: 200, height: 200)
        bottomImage!.draw(in: areaSize)

        topImage!.draw(in: areaSize1, blendMode: .normal, alpha: 0.8)

        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
