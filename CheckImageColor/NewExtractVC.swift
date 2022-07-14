//
//  NewExtractVC.swift
//  CheckImageColor
//
//  Created by Ramkumar J on 14/07/22.
//

import UIKit

class NewExtractVC: UIViewController {
    
    var totalImages = [UIImage]()
    
    @IBOutlet weak var img1x: UIImageView!
    @IBOutlet weak var img2x: UIImageView!
    @IBOutlet weak var img3x: UIImageView!
    
    @IBOutlet weak var txt1x: UILabel!
    @IBOutlet weak var txt2x: UILabel!
    @IBOutlet weak var txt3x: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.img1x.image = totalImages[0]
        self.img2x.image = totalImages[1]
        self.img3x.image = totalImages[2]
        
        self.txt1x.text = "\(totalImages[0].cgImage!.width) x \(totalImages[0].cgImage!.height)"
        self.txt2x.text = "\(totalImages[1].cgImage!.width) x \(totalImages[0].cgImage!.height)"
        self.txt3x.text = "\(totalImages[2].cgImage!.width) x \(totalImages[0].cgImage!.height)"
        // Do any additional setup after loading the view.
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
