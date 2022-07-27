//
//  AppendImageVC.swift
//  CheckImageColor
//
//  Created by Ramkumar J on 27/07/22.
//

import UIKit
import CoreGraphics

class AppendImageVC: UIViewController {
    
    @IBOutlet weak var sampImage: UIImageView!
    @IBOutlet weak var sam2: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        sampImage.backgroundColor = .green
        print(sampImage.image?.cgImage?.width, sampImage.image?.cgImage?.height)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func takeScreenShot(sender: UIButton){
        // Begin context
        UIGraphicsBeginImageContextWithOptions(sampImage.bounds.size, false, UIScreen.main.scale)

            // Draw view in that context
        sampImage.drawHierarchy(in: sampImage.bounds, afterScreenUpdates: true)
            
            // And finally, get image
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            sam2.image = image
        print(image?.cgImage?.width, image?.cgImage?.height)
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
