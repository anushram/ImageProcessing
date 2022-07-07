//
//  ViewController.swift
//  CheckImageColor
//
//  Created by K Saravana Kumar on 25/02/22.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
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
        UIImageWriteToSavedPhotosAlbum(immmmmmmm, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        //let processedImage = img?.processPixels(in: img!)
       // iiiimmmmm.image = processedImage
    }
    
    //MARK: - Add image to Library
        @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if let error = error {
                // we got back an error!
                showAlertWith(title: "Save error", message: error.localizedDescription)
            } else {
                showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
            }
        }

        func showAlertWith(title: String, message: String){
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
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
        let abc = CFDataCreateMutable(kCFAllocatorDefault, data.count * MemoryLayout<Any>.size)
        let providerRef = CGDataProvider(
            data: NSData(bytes: &data, length: data.count * MemoryLayout<Any>.size)
                )
        CFDataCreateMutable(kCFAllocatorDefault, data.count * MemoryLayout<Any>.size)
        //let providerRef = CGDataProvider(data: data as! CFData)
        //let nnnn = cgImage.dataProvider!
        let tt = (cgImage.width * Int(0.1)) * (cgImage.height * Int(0.1))
        print("mmdjd",(cgImage.bytesPerRow))
        //((cgImage.width * (Int(1.99))))
        //((cgImage.height * (Int(1.99))))
        //(cgImage.bytesPerRow)
        let cgim = CGImage(
            width: Int(135),
            height: Int(114),
            bitsPerComponent: Int(bitsPerComponent),
            bitsPerPixel: Int(bitsPerPixel),
            bytesPerRow: Int(540),
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
        
        
        
        for i in stride(from: 0 as CGFloat, to: (height), by: +8 as CGFloat) {
            
            var newOne = [PixelData]()
            
            for j in stride(from: 0 as CGFloat, to: (width), by: +8 as CGFloat) {
                
                let cgPoint = CGPoint.init(x: i, y: j)
                
                let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
                //As per row and column, we get all pixel values
                let check = (Int(width) * Int(i)) + Int(j)
                print("tokennn=",check)
                var totalPixelInfo = [Int]()
                for widthInc in 0..<8 {
                    for rowInc in 0..<8 {
                        
                        
                            let checkWid = ((CGFloat(widthInc) * (width - 1)) + (j + CGFloat(rowInc)))
                            let remainder = CGFloat( checkWid / ((CGFloat(widthInc) * (width - 1)) + (width - 1)))
                        let a = (CGFloat(rowInc) * (height - 1))
                        let checkhgt = a + (i + CGFloat(widthInc))
                        let remainderhgt = CGFloat(checkhgt / ((CGFloat(rowInc) * (height - 1)) + (height - 1)))
                        
                            if remainder > 1 {
                                continue
                            }else if remainderhgt > 1{
                                continue
                            }
                            else{
                                let pixelInfo: Int = ((Int(width) * Int(i + CGFloat(widthInc))) + Int(j + CGFloat(rowInc))) * 4
                                totalPixelInfo.append(pixelInfo)
                            }
                        
                    }
                }
                
                //Arrange color by pixel data
                
                var totalPixelData = [PixelData]()
                for pixelInfo in totalPixelInfo {
                    let pixelData = PixelData.init(r: data[pixelInfo+2], g: data[pixelInfo+1], b: data[pixelInfo], a: data[pixelInfo+3])
                    totalPixelData.append(pixelData)
                }
                
                //Add total red, blue, green, alpha
                var redTotal: Int = 0
                var blueTotal: Int = 0
                var greenTotal: Int = 0
                var alphaTotal: Int = 0
                for pixel in totalPixelData {
                    redTotal += Int(pixel.r)
                    greenTotal += Int(pixel.g)
                    blueTotal += Int(pixel.b)
                    alphaTotal += Int(pixel.a)
                }
                
                let avgR = UInt8(redTotal/totalPixelData.count)
                let avgG = UInt8(greenTotal/totalPixelData.count)
                let avgB = UInt8(blueTotal/totalPixelData.count)
                let avgA = UInt8(alphaTotal/totalPixelData.count)
                
                let picc = PixelData.init(r: avgR, g: avgG, b: avgB, a: avgA)
        
                newOne.append(picc)

//                let pixelInfo: Int = ((Int(width) * Int(i)) + Int(j)) * 4
//                let pixelInfoOne: Int = ((Int(width) * Int(i)) + Int(j + 1)) * 4
//                let pixelInfoTwo: Int = ((Int(width) * Int(i)) + Int(j + 2)) * 4
//                let pixelInfoThree: Int = ((Int(width) * Int(i)) + Int(j + 3)) * 4
//
//                let pixelInfoRowOne: Int = ((Int(width) * Int(i + 1)) + Int(j)) * 4
//                let pixelInfoRowTwo: Int = ((Int(width) * Int(i + 1)) + Int(j + 1)) * 4
//                let pixelInfoRowthree: Int = ((Int(width) * Int(i + 1)) + Int(j + 2)) * 4
//                let pixelInfoRowFour: Int = ((Int(width) * Int(i + 1)) + Int(j + 3)) * 4
//
//                let pixelInfoRow2: Int = ((Int(width) * Int(i + 2)) + Int(j)) * 4
//                let pixelInfoRowTwo2: Int = ((Int(width) * Int(i + 2)) + Int(j + 1)) * 4
//                let pixelInfoRowthree2: Int = ((Int(width) * Int(i + 2)) + Int(j + 2)) * 4
//                let pixelInfoRowFour2: Int = ((Int(width) * Int(i + 2)) + Int(j + 3)) * 4
//
//                let pixelInfoRowOne3: Int = ((Int(width) * Int(i + 3)) + Int(j)) * 4
//                let pixelInfoRowTwo3: Int = ((Int(width) * Int(i + 3)) + Int(j + 1)) * 4
//                let pixelInfoRowthree3: Int = ((Int(width) * Int(i + 3)) + Int(j + 2)) * 4
//                let pixelInfoRowFour3: Int = ((Int(width) * Int(i + 3)) + Int(j + 3)) * 4
//
//
//
//                let piccOne = PixelData.init(r: data[pixelInfo+2], g: data[pixelInfo+1], b: data[pixelInfo], a: data[pixelInfo+3])
//
//                let piccTwo = PixelData.init(r: data[pixelInfoOne+2], g: data[pixelInfoOne+1], b: data[pixelInfoOne], a: data[pixelInfoOne+3])
//
//                let piccThree = PixelData.init(r: data[pixelInfoTwo+2], g: data[pixelInfoTwo+1], b: data[pixelInfoTwo], a: data[pixelInfoTwo+3])
//
//                let piccFour = PixelData.init(r: data[pixelInfoThree+2], g: data[pixelInfoThree+1], b: data[pixelInfoThree], a: data[pixelInfoThree+3])
//
//
//
//                let piccOne1 = PixelData.init(r: data[pixelInfoRowOne+2], g: data[pixelInfoRowOne+1], b: data[pixelInfoRowOne], a: data[pixelInfoRowOne+3])
//
//                let piccTwo1 = PixelData.init(r: data[pixelInfoRowTwo+2], g: data[pixelInfoRowTwo+1], b: data[pixelInfoRowTwo], a: data[pixelInfoRowTwo+3])
//
//                let piccThree1 = PixelData.init(r: data[pixelInfoRowthree+2], g: data[pixelInfoRowthree+1], b: data[pixelInfoRowthree], a: data[pixelInfoRowthree+3])
//
//                let piccFour1 = PixelData.init(r: data[pixelInfoRowFour+2], g: data[pixelInfoRowFour+1], b: data[pixelInfoRowFour], a: data[pixelInfoRowFour+3])
//
//
//                //3
//                let piccOne2 = PixelData.init(r: data[pixelInfoRow2+2], g: data[pixelInfoRow2+1], b: data[pixelInfoRow2], a: data[pixelInfoRow2+3])
//
//                let piccTwo2 = PixelData.init(r: data[pixelInfoRowTwo2+2], g: data[pixelInfoRowTwo2+1], b: data[pixelInfoRowTwo2], a: data[pixelInfoRowTwo2+3])
//
//                let piccThree2 = PixelData.init(r: data[pixelInfoRowthree2+2], g: data[pixelInfoRowthree2+1], b: data[pixelInfoRowthree2], a: data[pixelInfoRowthree2+3])
//
//                let piccFour2 = PixelData.init(r: data[pixelInfoRowFour2+2], g: data[pixelInfoRowFour2+1], b: data[pixelInfoRowFour2], a: data[pixelInfoRowFour2+3])
//
//                //4
//
//                let piccOne3 = PixelData.init(r: data[pixelInfoRowOne3+2], g: data[pixelInfoRowOne3+1], b: data[pixelInfoRowOne3], a: data[pixelInfoRowOne3+3])
//
//                let piccTwo3 = PixelData.init(r: data[pixelInfoRowTwo3+2], g: data[pixelInfoRowTwo3+1], b: data[pixelInfoRowTwo3], a: data[pixelInfoRowTwo3+3])
//
//                let piccThree3 = PixelData.init(r: data[pixelInfoRowthree3+2], g: data[pixelInfoRowthree3+1], b: data[pixelInfoRowthree3], a: data[pixelInfoRowthree3+3])
//
//                let piccFour3 = PixelData.init(r: data[pixelInfoRowFour3+2], g: data[pixelInfoRowFour3+1], b: data[pixelInfoRowFour3], a: data[pixelInfoRowFour3+3])
//                //redSplit
//                let aRed1 = Int(piccOne.r) + Int(piccTwo.r) + Int(piccThree.r) + Int(piccFour.r) + Int(piccOne1.r) + Int(piccTwo1.r) + Int(piccThree1.r)
//
//                let aRed2 = Int(piccFour1.r) + Int(piccOne2.r) + Int(piccTwo2.r) + Int(piccThree2.r) + Int(piccFour2.r) + Int(piccOne3.r) + Int(piccTwo3.r) + Int(piccThree3.r) + Int(piccFour3.r)
//
//                let aRed = Int((aRed1 + aRed2) / 16)
//
//                let aGreen1 = Int(piccOne.g) + Int(piccTwo.g) + Int(piccThree.g) + Int(piccFour.g) + Int(piccOne1.g) + Int(piccTwo1.g) + Int(piccThree1.g)
//
//                let aGreen2 = Int(piccFour1.g) + Int(piccOne2.g) + Int(piccTwo2.g) + Int(piccThree2.g) + Int(piccFour2.g) + Int(piccOne3.g) + Int(piccTwo3.g) + Int(piccThree3.g) + Int(piccFour3.g)
//
//                let aGreen = Int((aGreen1 + aGreen2) / 16)
//
//
//                let aBlue1 = Int(piccOne.b) + Int(piccTwo.b) + Int(piccThree.b) + Int(piccFour.b) + Int(piccOne1.b) + Int(piccTwo1.b) + Int(piccThree1.b)
//
//                let aBlue2 = Int(piccFour1.b) + Int(piccOne2.b) + Int(piccTwo2.b) + Int(piccThree2.b) + Int(piccFour2.b) + Int(piccOne3.b) + Int(piccTwo3.b) + Int(piccThree3.b) + Int(piccFour3.b)
//
//                let aBlue = Int((aBlue1 + aBlue2) / 16)
//
//                let alpha1 = Int(piccOne.a) + Int(piccTwo.a) + Int(piccThree.a) + Int(piccFour.a) + Int(piccOne1.a) + Int(piccTwo1.a) + Int(piccThree1.a)
//
//                let alpha2 = Int(piccFour1.a) + Int(piccOne2.a) + Int(piccTwo2.a) + Int(piccThree2.a) + Int(piccFour2.a) + Int(piccOne3.a) + Int(piccTwo3.a) + Int(piccThree3.a) + Int(piccFour3.a)
//
//                let alpha = Int((alpha1 + alpha2) / 16)
//
//                let picc = PixelData.init(r: UInt8(aRed), g: UInt8(aGreen), b: UInt8(aBlue), a: UInt8(alpha))
//
//                    newOne.append(picc)
                
                
            }
                piii.append(contentsOf: newOne)
            
        }
        
    }
    /*Enlarge Image
    func GetTotalColors(height: CGFloat, width: CGFloat) {
        
        
        
        for i in stride(from: 0 as CGFloat, to: (height), by: +2 as CGFloat) {
            
            var newOne = [PixelData]()
            
            for j in stride(from: 0 as CGFloat, to: (width), by: +2 as CGFloat) {
                
                let cgPoint = CGPoint.init(x: i, y: j)
                
                let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

                let pixelInfo: Int = ((Int(width) * Int(i)) + Int(j)) * 4
                
                let piccOne = PixelData.init(r: data[pixelInfo+2], g: data[pixelInfo+1], b: data[pixelInfo], a: data[pixelInfo+3])
        
                    newOne.append(piccOne)
                
                
            }
                piii.append(contentsOf: newOne)
            
        }
        
    }
*/
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
