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
            self.images.append(UIImage(cgImage: image!))
            if self.imageCount == self.images.count {
                completion(true)
            }
        }
    }
}
