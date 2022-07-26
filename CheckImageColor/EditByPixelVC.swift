//
//  EditByPixelVC.swift
//  CheckImageColor
//
//  Created by Ramkumar J on 26/07/22.
//

import UIKit

class EditByPixelVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var widthTxt: UITextField!
    @IBOutlet weak var heightTxt: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.heightTxt.resignFirstResponder()
        self.widthTxt.resignFirstResponder()
        return true
    }
    
    @IBAction func convertAction(sender: UIButton){
        
        let image = UIImage.init(named: "sample")
        print(image!.cgImage!.width, image!.cgImage!.height)
        
        print(Double(5.0/2.0))
        
        let targetSize = CGSize(width: Double(8)/Double(2), height: Double(5)/Double(2))

        let scaledImage = image!.scalePreservingAspectRatio(
            targetSize: targetSize
        )
        
        print(scaledImage.cgImage!.width, scaledImage.cgImage!.height)
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

extension UIImage {
func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
    
}
