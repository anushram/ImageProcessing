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
    
    var identifier : imageProcess = .extract
    
    
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
        
        //self.selectedImg = UIImage.init(named: "sample")
        if self.selectedImg != nil {
            if let selectedCGImage = self.selectedImg?.cgImage {
            pixelData = selectedCGImage.dataProvider!.data
                
                    extractedImages.removeAll()
                
                if identifier == .extract {
                    
                    if selectedCGImage.colorSpace == rgbColorSpaceD{
                        let image2x = self.GetTotalColorsForReduction(height: CGFloat(selectedCGImage.height), width: CGFloat(selectedCGImage.width), ext: 2.0, cgImage: selectedCGImage)
                        extractedImages.append(self.selectedImg!)
                        extractedImages.append(image2x)
                        let image3x = self.GetTotalColorsForReduction(height: CGFloat(selectedCGImage.height), width: CGFloat(selectedCGImage.width), ext: 3.0, cgImage: selectedCGImage)
                        extractedImages.append(image3x)
                        self.performSegue(withIdentifier: "toShowNewExtract", sender: self)
                        return
                    }else{
                        let image2x = self.GetTotalColorsReductionRGB(height: CGFloat(selectedCGImage.height), width: CGFloat(selectedCGImage.width), ext: 2.0, cgImage: selectedCGImage)
                        extractedImages.append(self.selectedImg!)
                        extractedImages.append(image2x)
                        let image3x = self.GetTotalColorsReductionRGB(height: CGFloat(selectedCGImage.height), width: CGFloat(selectedCGImage.width), ext: 3.0, cgImage: selectedCGImage)
                        extractedImages.append(image3x)
                        self.performSegue(withIdentifier: "toShowNewExtract", sender: self)
                        return
                    }
                    
                }
            
                if selectedCGImage.colorSpace == rgbColorSpaceD{
                    extractedImages.removeAll()
                    let image2x = self.GetTotalColorsDp3(height: CGFloat(selectedCGImage.height), width: CGFloat(selectedCGImage.width), ext: 2, cgImage: selectedCGImage)
                    print(image2x.cgImage?.height,image2x.cgImage?.width)

                     let image3x = self.GetTotalColorsDp3(height: CGFloat(selectedCGImage.height), width: CGFloat(selectedCGImage.width), ext: 3, cgImage: selectedCGImage)
                    print(image3x.cgImage?.height,image3x.cgImage?.width)

                     extractedImages.append(self.selectedImg!)
                     extractedImages.append(image2x)
                     extractedImages.append(image3x)
                        self.performSegue(withIdentifier: "toShowNewExtract", sender: self)
                }else{
                    extractedImages.removeAll()
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
            //self.selectedImgView.image = UIImage.init(named: "sample")
                self.selectedImg = img
                //self.selectedImg = UIImage.init(named: "sample")
                let cgimg = self.selectedImg!.cgImage
                print(cgimg!.colorSpace)
                print(cgimg!.colorSpace?.numberOfComponents)
                print("total sizeees=",cgimg?.width, cgimg?.height)
                sizeImg.text = "\(cgimg!.width) X \(cgimg!.height)"
                self.dismiss(animated: true, completion: { () -> Void in

                })
            }
            
        }
    
    func GetTotalColorsDp3(height: CGFloat, width: CGFloat, ext: Int, cgImage: CGImage) -> UIImage {
        
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
    
    func GetTotalColors(height: CGFloat, width: CGFloat, ext: Int, cgImage: CGImage) -> UIImage {
        
        modifiedPixelData.removeAll()
        
        for i in stride(from: 0  as CGFloat, to: height, by: +1 as CGFloat) {
            
            var newOne = [PixelData]()
            
            for j in stride(from: 0 as CGFloat, to: width, by: +1 as CGFloat) {
                
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
    
    func GetTotalColorsForReduction(height: CGFloat, width: CGFloat, ext: CGFloat, cgImage: CGImage) -> UIImage {
        
        self.modifiedPixelData.removeAll()
        
        var subSlider = 0
        var subSliderOne = 0
//for i in stride(from: 0 as CGFloat, to: (height), by: +ext) {
        for i in stride(from: (height - 1) as CGFloat, to: -1, by: -ext) {
        //for i in stride(from: height, to: 0, by: CGFloat(-sliderValue)) {

            var newOne = [PixelData]()
            subSliderOne = Int(i - ext)
            for j in stride(from: (width - 1) as CGFloat, to: -1, by: -ext) {
            //for j in stride(from: (width), to: 0, by: CGFloat(-sliderValue)) {

                let cgPoint = CGPoint.init(x: i, y: j)

                let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
                //As per row and column, we get all pixel values
                let check = (Int(width) * Int(i)) + Int(j)

                subSlider  = Int(j) - Int(ext)
                //print("tokennn=",check)
                var totalPixelInfo = [Int]()
                var rowIncTag = 0
                var widthIncTag = 0
                for widthInc in stride(from: Int(i), to: subSliderOne, by: -1) {
                    for rowInc in stride(from: Int(j), to: subSlider, by: -1) {
                        
                        let pixelInfo1: Int = ((Int(width) * Int(i - CGFloat(widthIncTag))) + Int(j - CGFloat(rowIncTag)))
                        
                        let pixelInfoRow: Int = ((Int(height) * Int(j - CGFloat(rowIncTag))) + Int(i - CGFloat(widthIncTag)))
                        
                        let checkWid = (Int(Int(i + 1) - widthIncTag) * Int(width))
                        
                        let checkHt = (Int(Int(j + 1) - rowIncTag) * Int(height))
                        
                        
                        let remainder = (CGFloat(checkWid - (pixelInfo1)) / CGFloat(width))
                        
                        let remainderHeight = (CGFloat(checkHt - (pixelInfoRow)) / CGFloat(height))
                        
                        if checkWid == 13 {
                            
                        }
                        
                        print(remainder)
                        
                        if remainder > 1 {
                            continue
                        }
                        
                        if remainderHeight > 1 {
                            print(remainderHeight,checkWid)
                            continue
                        }
                        
                        


//                            let checkWid = ((CGFloat(widthIncTag) * (width - 1)) + (j + CGFloat(rowIncTag)))
//                            let remainder = CGFloat( checkWid / ((CGFloat(widthIncTag) * (width - 1)) + (width - 1)))
//                        let a = (CGFloat(rowIncTag) * (height - 1))
//                        let checkhgt = a + (i + CGFloat(widthIncTag))
//                        let remainderhgt = CGFloat(checkhgt / ((CGFloat(rowIncTag) * (height - 1)) + (height - 1)))
//
//                            if remainder > 0 {
//                                continue
//                            }else if remainderhgt > 0{
//                                continue
//                            }
//                            else{
//                                let pixelInfo: Int = ((Int(width) * Int(i - CGFloat(widthIncTag))) + Int(j - CGFloat(rowIncTag))) * 4
//                                totalPixelInfo.append(pixelInfo)
//                            }
                        
                        let pixelInfo: Int = ((Int(width) * Int(i - CGFloat(widthIncTag))) + Int(j - CGFloat(rowIncTag))) * 4
                        totalPixelInfo.append(pixelInfo)
                        
                        rowIncTag += 1

                    }
                    rowIncTag = 0
                    widthIncTag += 1
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
                
                if totalPixelData.count != 0 {
                    let picc = PixelData.init(r: avgR, g: avgG, b: avgB, a: avgA)

                    newOne.append(picc)
                }else{
//                    let picc = PixelData.init(r: 0, g: 0, b: 0, a: 0)
//                    newOne.append(picc)
                }
            }
                subSlider = 0
            modifiedPixelData.append(contentsOf: newOne)

        }
        return self.imageFromARGB32BitmapReduction(pixels: modifiedPixelData, width: width, height: height, cgImage: cgImage, ext: ext)
    }
    
    func GetTotalColorsReductionRGB(height: CGFloat, width: CGFloat, ext: CGFloat, cgImage: CGImage) -> UIImage {
        
        self.modifiedPixelData.removeAll()
        
        var subSlider = 0
        var subSliderOne = 0

        for i in stride(from: 0 as CGFloat, to: (height), by: +ext) {
        //for i in stride(from: height, to: 0, by: CGFloat(-sliderValue)) {

            var newOne = [PixelData]()
            subSliderOne = Int(i + ext)
            for j in stride(from: 0 as CGFloat, to: (width), by: +ext) {
            //for j in stride(from: (width), to: 0, by: CGFloat(-sliderValue)) {

                let cgPoint = CGPoint.init(x: i, y: j)

                let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
                //As per row and column, we get all pixel values
                let check = (Int(width) * Int(i)) + Int(j)

                subSlider  = Int(j) + Int(ext)
                //print("tokennn=",check)
                var totalPixelInfo = [Int]()
                var rowIncTag = 0
                var widthIncTag = 0
                for widthInc in Int(i)..<Int(subSliderOne) {
                    for rowInc in Int(j)..<Int(subSlider) {


                            let checkWid = ((CGFloat(widthIncTag) * (width - 1)) + (j + CGFloat(rowIncTag)))
                            let remainder = CGFloat( checkWid / ((CGFloat(widthIncTag) * (width - 1)) + (width - 1)))
                        let a = (CGFloat(rowIncTag) * (height - 1))
                        let checkhgt = a + (i + CGFloat(widthIncTag))
                        let remainderhgt = CGFloat(checkhgt / ((CGFloat(rowIncTag) * (height - 1)) + (height - 1)))

                            if remainder > 1 {
                                continue
                            }else if remainderhgt > 1{
                                continue
                            }
                            else{
                                let pixelInfo: Int = ((Int(width) * Int(i + CGFloat(widthIncTag))) + Int(j + CGFloat(rowIncTag))) * 4
                                totalPixelInfo.append(pixelInfo)
                            }
                        
                        rowIncTag += 1

                    }
                    rowIncTag = 0
                    widthIncTag += 1
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
                
                if totalPixelData.count != 0 {
                    let picc = PixelData.init(r: avgR, g: avgG, b: avgB, a: avgA)

                    newOne.append(picc)
                }else{
                    let picc = PixelData.init(r: 0, g: 0, b: 0, a: 0)
                    newOne.append(picc)
                }

                

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
                subSlider = 0
                modifiedPixelData.append(contentsOf: newOne)

        }
        
        return self.imageFromARGB32BitmapReduction(pixels: modifiedPixelData, width: width, height: height, cgImage: cgImage, ext: ext)

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
//        return UIImage.init(cgImage: cgim!, scale: self.selectedImg!.scale, orientation: .leftMirrored)
        
        return UIImage(cgImage: cgim!)
    }
    
    public func imageFromARGB32BitmapReduction(pixels:[PixelData], width:CGFloat, height:CGFloat, cgImage: CGImage, ext: CGFloat)->UIImage{
        
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
            width: Int(ceil(width/ext)),
            height: Int(ceil(height/ext)),
            bitsPerComponent: Int(bitsPerComponent),
            bitsPerPixel: Int(bitsPerPixel),
            bytesPerRow: Int((ceil(width/ext)) * 4),
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
