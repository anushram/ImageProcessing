//
//  ImagePickerVC.swift
//  CheckImageColor
//
//  Created by Ramkumar J on 14/07/22.
//

import UIKit

class ImagePickerVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var selectedImgView: UIImageView!
    @IBOutlet weak var sizeImg: UILabel!
    
    var selectedImg: UIImage?
    
    var pixelData: CFData?
    
    var modifiedPixelData = [PixelData]()
    
    var extractedImages = [UIImage]()
    
    private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    private let rgbColorSpaceD = CGColorSpace.init(name: CGColorSpace.displayP3)
    
    
    private let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        .union(.byteOrder32Little)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func convertAction(sender: UIButton){
        if self.selectedImg != nil {
            if let selectedCGImage = self.selectedImg?.cgImage {
            pixelData = selectedCGImage.dataProvider!.data
            let image2x = self.GetTotalColors(height: CGFloat(selectedCGImage.height), width: CGFloat(selectedCGImage.width), ext: 2, cgImage: selectedCGImage)
            print(image2x.cgImage?.height,image2x.cgImage?.width)
                
             let image3x = self.GetTotalColors(height: CGFloat(selectedCGImage.height), width: CGFloat(selectedCGImage.width), ext: 3, cgImage: selectedCGImage)
            print(image3x.cgImage?.height,image3x.cgImage?.width)
                
             extractedImages.append(self.selectedImg!)
             extractedImages.append(image2x)
             extractedImages.append(image3x)
                self.performSegue(withIdentifier: "toShowNewExtract", sender: self)
            }
        }
    }
    
    @IBAction func Chooseclicked() {

            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                print("Button capture")

                imagePicker.delegate = self
                imagePicker.sourceType = .savedPhotosAlbum
                imagePicker.allowsEditing = false

                present(imagePicker, animated: true, completion: nil)
            }
        }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let img = info[.originalImage] as? UIImage {
                
            self.selectedImgView.isHidden = false
            self.selectedImgView.image = img
                self.selectedImg = img
                let cgimg = self.selectedImg!.cgImage
                print(cgimg!.colorSpace)
                print(cgimg!.colorSpace?.numberOfComponents)
                print("total sizeees=",cgimg?.width, cgimg?.height)
                sizeImg.text = "\(cgimg!.width) X \(cgimg!.height)"
                self.dismiss(animated: true, completion: { () -> Void in

                })
            }
            
        }
    
    func GetTotalColors(height: CGFloat, width: CGFloat, ext: Int, cgImage: CGImage) -> UIImage {
        
        modifiedPixelData.removeAll()
        
        for i in stride(from: height as CGFloat, to: 0, by: -1 as CGFloat) {
            
            var newOne = [PixelData]()
            
            for j in stride(from: width as CGFloat, to: 0, by: -1 as CGFloat) {
                
                let cgPoint = CGPoint.init(x: i, y: j)
                
                let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

                let pixelInfo: Int = ((Int(width) * Int(i)) + Int(j)) * 4
                
                let pixData = PixelData.init(r: data[pixelInfo+2], g: data[pixelInfo+1], b: data[pixelInfo], a: data[pixelInfo+3])
                
                for _ in 1...ext {
                    newOne.append(pixData)
                }
        
                    
                
                
            }
            for _ in 1...ext {
                modifiedPixelData.append(contentsOf: newOne)
            }
            
            
        }
        return imageFromARGB32Bitmap(pixels: self.modifiedPixelData, width: width, height: height, cgImage: cgImage, ext: ext)
    }
    
    public func imageFromARGB32Bitmap(pixels:[PixelData], width:CGFloat, height:CGFloat, cgImage: CGImage, ext: Int)->UIImage{
        
        let bitsPerComponent:UInt = UInt(cgImage.bitsPerComponent)
        let bitsPerPixel:UInt = UInt(cgImage.bitsPerPixel)
        //assert(pixels.count == Int((width * height)) )
        var data = pixels // Copy to mutable []
        
        //let abc = CFDataCreateMutable(kCFAllocatorDefault, data.count * MemoryLayout<Any>.size)
        let dataONe = NSData(bytes: &data, length: data.count * 4)
           let providerRef = CGDataProvider(
            data:dataONe)
        //CFDataCreateMutable(kCFAllocatorDefault, data.count * MemoryLayout<Any>.size)
        
        let cgim = CGImage(
            width: Int(ceil(width * CGFloat(ext))),
            height: Int(ceil(height * CGFloat(ext))),
            bitsPerComponent: Int(bitsPerComponent),
            bitsPerPixel: Int(bitsPerPixel),
            bytesPerRow: Int((ceil(width * CGFloat(ext))) * 4),
            space: cgImage.colorSpace ?? rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef as! CGDataProvider,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent
                )
        //return UIImage.init(cgImage: cgim!, scale: img!.scale, orientation: .leftMirrored)
        
        return UIImage(cgImage: cgim!)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? NewExtractVC{
            view.totalImages = self.extractedImages
        }
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
