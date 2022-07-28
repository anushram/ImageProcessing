//
//  AppendImageVC.swift
//  CheckImageColor
//
//  Created by Ramkumar J on 27/07/22.
//

import UIKit
import CoreGraphics

class AppendImageVC: UIViewController {
    
    private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    private let rgbColorSpaceD = CGColorSpace.init(name: CGColorSpace.displayP3)
    
    
    private let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        .union(.byteOrder32Little)
    
    @IBOutlet weak var sampImage: UIImageView!
    @IBOutlet weak var sam2: UIImageView!
    
    var modifiedPixelData = [PixelData]()
    var pixelData: CFData?

    override func viewDidLoad() {
        super.viewDidLoad()
        //sampImage.backgroundColor = sampImage.image?.averageColor
        pixelData = sampImage.image!.cgImage!.dataProvider!.data
        print(sampImage.image?.averageColor)
        print(sampImage.image?.cgImage?.width, sampImage.image?.cgImage?.height)
        // Do any additional setup after loading the view.
       let image = GetTotalColors(height: 5, width: 10, ext: 1, cgImage: sampImage.image!.cgImage!)
        sampImage.image = image
    }
    
    @IBAction func takeScreenShot(sender: UIButton){
        // Begin context
        //        let size = CGSize.init(width: Double(sampImage.bounds.size.width) * 2.0, height: Double(sampImage.bounds.size.height))
        //        let sizeBounds = CGRect.init(origin: CGPoint.init(x: 0.0, y: 0.0), size: size)
        UIGraphicsBeginImageContextWithOptions(sampImage.bounds.size, false, UIScreen.main.scale)

            // Draw view in that context
        sampImage.drawHierarchy(in: sampImage.bounds, afterScreenUpdates: true)
            
            // And finally, get image
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            sam2.image = image
        print(image?.cgImage?.width, image?.cgImage?.height)
    }
    
    func GetTotalColors(height: CGFloat, width: CGFloat, ext: Int, cgImage: CGImage) -> UIImage {
        
        modifiedPixelData.removeAll()
        
        for i in stride(from: 0  as CGFloat, to: 5, by: +1 as CGFloat) {
            
            var newOne = [PixelData]()
            
            for j in stride(from: 0 as CGFloat, to: 11, by: +1 as CGFloat) {
                
                let cgPoint = CGPoint.init(x: i, y: j)
                
                let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

                
                let saImage = UIImage.init(named: "sample")!
                let ciComponenet = CIColor.init(color: saImage.averageColor!)
                
                if j > 2 && j <= 7 {
                    
//                    for k in stride(from: i  as CGFloat, to: i, by: +1 as CGFloat) {
                        
//                        for l in stride(from: 0  as CGFloat, to: 5, by: +1 as CGFloat) {
                            let pixelInfo: Int = ((Int(5) * Int(i)) + Int(j-3)) * 4
                            
                            let pixData = PixelData.init(r: data[pixelInfo+2], g: data[pixelInfo+1], b: data[pixelInfo], a: data[pixelInfo+3])
                            newOne.append(pixData)
//                        }
                        
//                    }
                    
                }else if j > 7{
                    let pixData = PixelData.init(r: UInt8(ciComponenet.blue * 255), g: UInt8(ciComponenet.green * 255 ), b: UInt8(ciComponenet.red * 255), a: UInt8(ciComponenet.alpha * 255))
    //                    let pixData = PixelData.init(r: UInt8(255), g: UInt8(0), b: UInt8(0), a: UInt8(255))
                    
                        newOne.append(pixData)
                }
                else{
                    
                   print("redCCC=",(ciComponenet.red * 255))
                
                let pixData = PixelData.init(r: UInt8(ciComponenet.blue * 255), g: UInt8(ciComponenet.green * 255 ), b: UInt8(ciComponenet.red * 255), a: UInt8(ciComponenet.alpha * 255))
//                    let pixData = PixelData.init(r: UInt8(255), g: UInt8(0), b: UInt8(0), a: UInt8(255))
                
                    newOne.append(pixData)
        
                }
                
                
            }
                modifiedPixelData.append(contentsOf: newOne)
            
            
        }
        return imageFromARGB32Bitmap(pixels: self.modifiedPixelData, width: 11, height: 5, cgImage: cgImage, ext: ext)
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
            width: Int(width),
            height: Int(height),
            bitsPerComponent: Int(bitsPerComponent),
            bitsPerPixel: Int(bitsPerPixel),
            bytesPerRow: Int((ceil(width * CGFloat(ext))) * 4),
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef as! CGDataProvider,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent
                )
//        return UIImage.init(cgImage: cgim!, scale: self.selectedImg!.scale, orientation: .leftMirrored)
        
        return UIImage(cgImage: cgim!)
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

