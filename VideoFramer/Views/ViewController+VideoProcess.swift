//
//  ViewController+VideoProcess.swift
//  VideoFramer
//
//  Created by Amr on 03/01/2022.
//

import UIKit
import AssetsLibrary
import AVFoundation

extension ViewController {

    func genrateImagesFromVideoUrl(url: NSURL){
        let videoAsset = AVAsset(url: url as URL)
        videoDuration = Int(videoAsset.duration.seconds)
        imageCount = Int(((videoDuration ?? 0) / 30)) + 1
        
        for _ in 0..<imageCount!{
            let t1 = CMTime(value: CMTimeValue(firstTime), timescale: 1)
            timesArray.append(NSValue(time: t1))
            firstTime = firstTime + 30
        }

      
        genrateImages(videoAsset: videoAsset) { Done in
            if Done {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    func genrateImages(videoAsset : AVAsset ,
                       completion: @escaping (_ Done: Bool) -> ()) {
        let generator = AVAssetImageGenerator(asset: videoAsset)
        generator.appliesPreferredTrackTransform = true
        generator.generateCGImagesAsynchronously(forTimes: timesArray ) { requestedTime, image, actualTime, result, error in
            let OriginalImage = UIImage(cgImage: image!)
            let BlurredImage  = self.blurEffect(image: OriginalImage)
            self.images.append(BlurredImage)
            UIImageWriteToSavedPhotosAlbum(BlurredImage, nil, nil, nil)

            if self.imageCount == self.images.count {
                completion(true)
            }
        }
    }
    
    func blurEffect(image : UIImage) -> UIImage{

        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: image)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(10, forKey: kCIInputRadiusKey)

        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")

        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        return processedImage
    }
    
}
