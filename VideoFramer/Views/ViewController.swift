//
//  ViewController.swift
//  VideoFramer
//
//  Created by Amr on 03/01/2022.
//

import UIKit
import MobileCoreServices
import AVFoundation
import AssetsLibrary

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let imagePickerController = UIImagePickerController()
    var videoURL : NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FrameCell.self, forCellWithReuseIdentifier: "FrameCell")

    }

    @IBAction func importVedioBtnPressed(_ sender: Any) {
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeMovie as String]
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension ViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}
