//
//  ViewController.swift
//  CheckImageColor
//
//  Created by K Saravana Kumar on 25/02/22.
//

import UIKit

class ViewController: UIViewController {
    
    var img: UIImage?
    var pixelData: CFData?
    
    @IBOutlet weak var iiiimmmmm: UIImageView!
    
    var piii = [PixelData]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        img = UIImage.init(named: "sample")
        var cccGImage = img?.cgImage!
        pixelData = cccGImage!.dataProvider!.data
        let coo = img?.averageColor
        print(coo)
        
        let heightInPoints = img!.size.height
        let heightInPixels = heightInPoints * img!.scale

        let widthInPoints = img!.size.width
        let widthInPixels = widthInPoints * img!.scale
        
        let cgPoint = CGPoint.init(x: 1.5, y: 1.5)
        let colorpp = img?.getPixelColor(pos: cgPoint, pixelData: self.pixelData!)
        print("sssss",colorpp)
        
        self.GetTotalColors(height: CGFloat(cccGImage!.height), width: CGFloat(cccGImage!.width))
        let immmmmmmm = self.imageFromARGB32Bitmap(pixels: self.piii, width: UInt(cccGImage!.width), height: UInt(cccGImage!.height), cgImage: cccGImage!)
        var cgggggimmmm = immmmmmmm.cgImage
        print("total sizeees=",cgggggimmmm?.width, cgggggimmmm?.height)
        iiiimmmmm.image = immmmmmmm
        //let processedImage = img?.processPixels(in: img!)
       // iiiimmmmm.image = processedImage
    }
    
    public struct PixelData {
        var r:UInt8
        var g:UInt8
        var b:UInt8
        var a:UInt8
    }
    
    private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    
    
    private let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        .union(.byteOrder32Little)
    public func imageFromARGB32Bitmap(pixels:[PixelData], width:UInt, height:UInt, cgImage: CGImage)->UIImage{
        
        let bitsPerComponent:UInt = 8
        let bitsPerPixel:UInt = 32
        //assert(pixels.count == Int((width * height)) )
        var data = pixels // Copy to mutable []
        let providerRef = CGDataProvider(
            data: NSData(bytes: &data, length: data.count * MemoryLayout<Any>.size)
                )
        //let providerRef = CGDataProvider(data: data as! CFData)
        //let nnnn = cgImage.dataProvider!
        let tt = (cgImage.width * Int(0.1)) * (cgImage.height * Int(0.1))
        print("mmdjd",(cgImage.bytesPerRow))
        //((cgImage.width * (Int(1.99))))
        //((cgImage.height * (Int(1.99))))
        //(cgImage.bytesPerRow)
        let cgim = CGImage(
            width: 2160,
            height: 1824,
            bitsPerComponent: Int(bitsPerComponent),
            bitsPerPixel: Int(bitsPerPixel),
            bytesPerRow: 8640,
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef!,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent
                )
        print("cccccccc=",img!.scale)
        //return UIImage.init(cgImage: cgim!, scale: img!.scale, orientation: .leftMirrored)
        
        return UIImage(cgImage: cgim!)
    }

    func GetTotalColors(height: CGFloat, width: CGFloat) {
        
        
        
        for i in stride(from: 0 as CGFloat, to: (height), by: +1 as CGFloat) {
            
            var newOne = [PixelData]()
            
            for j in stride(from: 0 as CGFloat, to: (width), by: +1 as CGFloat) {
                
                let cgPoint = CGPoint.init(x: i, y: j)
                //let colorpp = img!.getPixelColor(pos: cgPoint, pixelData: pixelData!)
               // print("sssss\(i) \(j)", colorpp)
                
                let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

                let pixelInfo: Int = ((Int(width) * Int(i)) + Int(j)) * 4
                
                //let picc = PixelData.init(r: 14, g: 45, b: 23)
                //let picc1 = PixelData.init(r: 255, g: 0, b: 0)
                //let picc2 = PixelData.init(r: 0, g: 255, b: 255)
                //let picc3 = PixelData.init(r: 255, g: 0, b: 0)
                let piccOne = PixelData.init(r: data[pixelInfo+2], g: data[pixelInfo+1], b: data[pixelInfo], a: data[pixelInfo+3])
                //let piccOne = PixelData.init(a: 255, r: data[pixelInfo], g: data[pixelInfo+1], b: data[pixelInfo+2])
                piii.append(piccOne)
                piii.append(piccOne)
                newOne.append(piccOne)
                newOne.append(piccOne)
//                let r = CGFloat(data[pixelInfo])
//                let g = CGFloat(data[pixelInfo+1])
//                let b = CGFloat(data[pixelInfo+2])
//                let a = CGFloat(data[pixelInfo+3])
                
//                piii.append(picc1)
//                piii.append(picc2)
//                piii.append(picc3)
//                piii.append(picc)
//                piii.append(picc1)
//                piii.append(picc2)
//                piii.append(picc3)
               // piii.append(picc)
              //  piii.append(picc)
               // piii.append(picc)
               // piii.append(picc)
//                piii.append(picc)
//                piii.append(picc)
//                piii.append(picc)
  //              let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
  //              let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
  //              let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
  //              let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
                
                //let pixelBuffer = data.bindMemory(to: UIColor.self, capacity: width * height)
          
              
                
              
                
            }
            
            piii.append(contentsOf: newOne)
        }
        
    }

}



extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
    
    func getPixelColor(pos: CGPoint, pixelData: CFData) -> UIColor {

        
              let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

              let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
//        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x))

//              let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
//              let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
//              let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
//              let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
            
        
            let r = CGFloat(data[pixelInfo])
            let g = CGFloat(data[pixelInfo+1])
            let b = CGFloat(data[pixelInfo+2])
            let a = CGFloat(data[pixelInfo+3])
        
        

              return UIColor(red: r, green: g, blue: b, alpha: a)
          }
    
    func processPixels(in image: UIImage) -> UIImage? {
        
        guard let inputCGImage = image.cgImage else {
               print("unable to get cgImage")
               return nil
           }
        
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
            let width            = inputCGImage.width
            let height           = inputCGImage.height
            let bytesPerPixel    = 4
            let bitsPerComponent = 8
            let bytesPerRow      = bytesPerPixel * width
            let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
                print("unable to create context")
                return nil
            }
            context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))

            guard let buffer = context.data else {
                print("unable to get context data")
                return nil
            }
        
//        let dataOne = UnsafeRawPointer(inputCGImage.pointee).assumingMemoryBound(to: UInt8.self)


        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        let buuubuffer = buffer.bindMemory(to: (UInt32, UInt32, UInt32, UInt32).self, capacity: width * height)
        //let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        
//        pixelBuffer[1444] = .red
//        pixelBuffer[1445] = .red
//        pixelBuffer[1446] = .red
//        pixelBuffer[1447] = .red
//        pixelBuffer[1448] = .red
//        pixelBuffer[1449] = .red
//        pixelBuffer[1450] = .red
//        pixelBuffer[1451] = .red
//        pixelBuffer[1452] = .red
//        pixelBuffer[1453] = .red
//        pixelBuffer[1454] = .red
//        pixelBuffer[1455] = .red
//        pixelBuffer[1456] = .red
//        pixelBuffer[1457] = .red
        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                if pixelBuffer[offset].redComponent == 22 &&  pixelBuffer[offset].greenComponent == 84 &&  pixelBuffer[offset].blueComponent == 97 &&  pixelBuffer[offset].alphaComponent == 255 {
                    pixelBuffer[offset] = .trans
                }
            }
        }
        let outputCGImage = context.makeImage()!
            let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
        return outputImage
        
    }
    
    struct RGBA32: Equatable {
        private var color: UInt32

        var redComponent: UInt8 {
            return UInt8((color >> 24) & 255)
        }

        var greenComponent: UInt8 {
            return UInt8((color >> 16) & 255)
        }

        var blueComponent: UInt8 {
            return UInt8((color >> 8) & 255)
        }

        var alphaComponent: UInt8 {
            return UInt8((color >> 0) & 255)
        }

        init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
            let red   = UInt32(red)
            let green = UInt32(green)
            let blue  = UInt32(blue)
            let alpha = UInt32(alpha)
            color = (red << 24) | (green << 16) | (blue << 8) | (alpha << 0)
            
            
        }

        static let red     = RGBA32(red: 255, green: 0,   blue: 0,   alpha: 255)
        static let green   = RGBA32(red: 0,   green: 255, blue: 0,   alpha: 255)
        static let blue    = RGBA32(red: 0,   green: 0,   blue: 255, alpha: 255)
        static let white   = RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
        static let black   = RGBA32(red: 22,   green: 84,   blue: 97,   alpha: 255)
        static let magenta = RGBA32(red: 255, green: 0,   blue: 255, alpha: 255)
        static let yellow  = RGBA32(red: 255, green: 255, blue: 0,   alpha: 255)
        static let cyan    = RGBA32(red: 0,   green: 255, blue: 255, alpha: 255)
        static let trans    = RGBA32(red: 0,   green: 0, blue: 0, alpha: 0)

        static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue

        static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
            return lhs.color == rhs.color
        }
    }
}
