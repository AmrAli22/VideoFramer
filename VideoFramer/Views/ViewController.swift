//
//  ViewController.swift
//  VideoFramer
//
//  Created by Amr on 03/01/2022.
//

import UIKit
import MobileCoreServices
import AVFoundation


class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - vedioPicker
    let vedioPicker = UIImagePickerController()
    var videoURL : NSURL?
    // MARK: - vedioDurationTimes
    var firstTime = 0
    var videoDuration  : Int?
    var timesArray = [NSValue]()
    // MARK: - vedioDurationTimes1
    var imageCount : Int?
    var images = [UIImage]()
    // MARK: - blurEffectContext
    var context = CIContext(options: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FrameCell", bundle: nil), forCellWithReuseIdentifier: "FrameCell")
    }

    @IBAction func importVedioBtnPressed(_ sender: Any) {
        emptyData()
        vedioPicker.sourceType = .savedPhotosAlbum
        vedioPicker.delegate = self
        vedioPicker.mediaTypes = [kUTTypeMovie as String]
        present(vedioPicker, animated: true, completion: nil)
    }
    
    func emptyData(){
        imageCount = nil
        images = [UIImage]()
        timesArray = [NSValue]()
        videoDuration = nil
        firstTime = 0
        videoURL = nil
        collectionView.reloadData()
    }
    
}

extension ViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
        guard let vedioUrl = videoURL else { return }
        genrateImagesFromVideoUrl(url: vedioUrl)
        vedioPicker.dismiss(animated: true, completion: nil)
    }
}
