//
//  ViewController.swift
//  Gridy
//
//  Created by Ahmad Murad on 07/06/2019.
//  Copyright © 2019 Ahmad Murad. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var gridyPickButton: UIButton!
    @IBOutlet weak var CameraButton: UIButton!
    @IBOutlet weak var librarButton: UIButton!
    
    // ** Variables **
    // Global array of images to hold local images
    var localImages = [UIImage]()
    // defaults object to save a reference of last image picked randomly
    let defaults = UserDefaults.standard
    // image variable to hold the user chosen image
    var userChosenImage = UIImage()
    
    // ** Buttons **
    @IBAction func gridyPick(_ sender: Any) {
        pickRandom()
    }
    @IBAction func cameraPick(_ sender: Any) {
        displayCamera()
    }
    @IBAction func libraryPick(_ sender: Any) {
        displayLibrary()
    }
    
    
    func displayCamera() {
        let sourceType = UIImagePickerController.SourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let noPermissionMessage = "looks like Gridy has no access to your camera, please go to settings on your device to permit Gridy accessing your camera"
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch status {
            case .notDetermined :
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                    if granted {
                        self.presentPhoto(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                }
            case .authorized :
                self.presentPhoto(sourceType: sourceType)
            case .denied, .restricted :
                self.troubleAlert(message: noPermissionMessage)
            }
        } else {
            troubleAlert(message: "Sincere apologies, it looks like we can't access your camera at this time")
        }
    }
    
    func displayLibrary() {
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let noPermissionMessage = "looks like Gridy has no access to your library, please go to settings on your device to permit Gridy accessing your library"
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .notDetermined :
                PHPhotoLibrary.requestAuthorization { (granted) in
                    if granted == .authorized {
                        self.presentPhoto(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                }
            case .authorized :
                self.presentPhoto(sourceType: sourceType)
            case .denied, .restricted :
                self.troubleAlert(message: noPermissionMessage)
            }
        } else {
            troubleAlert(message: "Sincere apologies, it looks like we can't access your photo library at this time")
        }
    }
    
    func presentPhoto(sourceType: UIImagePickerController.SourceType) {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = sourceType
        present(photoPicker, animated: true)
    }
    
    func troubleAlert(message: String?) {
        let alertController = UIAlertController(title: "Ooops", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Got it", style: .cancel)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let pickedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided with the following: \(info)")
        }
        userChosenImage = pickedImage
        performSegue(withIdentifier: "goToAdjustImage", sender: self)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
 
    // MARK: - ****************Gridy random pick****************
    
    func collectLocalImages() {
        localImages.removeAll()
        let localImagesNames = ["Boats", "Car", "Crocodile", "Park", "TShirts"]
        for name in localImagesNames {
            if let image = UIImage(named: name) {
                localImages.append(image)
            }
        }
    }
    
    // Global constant that holds the key for lastImageIndex, created to make it lesser prone to errors
    private let localImageIndex = "imageIndex"
    // calculated variable to store the index(Integer value) of the last randolmly picked image from the array localImages
    private var lastImageIndex: Int {
        get {
            let savedIndex = defaults.value(forKey: localImageIndex)
            if savedIndex == nil {
                // initially assign the savedIndex the last index of the last image in localImages
                defaults.set(localImages.count - 1, forKey: localImageIndex)
            }
            return defaults.integer(forKey: localImageIndex)
        }
        set {
            // make sure that the value taht we're trying to pass is between zero and the last index of localImages elements, and if it is within the range then we're saving the value we're provided
            if newValue >= 0 && newValue < localImages.count {
                defaults.set(newValue, forKey: localImageIndex)
            }
        }
    }
    
    func randomImage() -> UIImage? {
        let lastPickedImage = localImages[lastImageIndex]
        if localImages.count > 0 {
            while true {
                let randomImageNumber = Int.random(in: 0...localImages.count - 1)
                let newImage = localImages[randomImageNumber]
                if newImage != lastPickedImage {
                    lastImageIndex = randomImageNumber
                    return newImage
            }
        }
    }
        return nil
    }
    
    func pickRandom() {
        userChosenImage = randomImage() ?? localImages[0]
        performSegue(withIdentifier: "goToAdjustImage", sender: self)
    }
   
    // MARK: - *****Configuration functionality*****
    
    func rounded(button: UIButton) {
        var roundedButton = RoundedButton()
        roundedButton.setButton(button)
        roundedButton.rounded()
    }
    
    func configure() {
        collectLocalImages()
        rounded(button: gridyPickButton)
        rounded(button: CameraButton)
        rounded(button: librarButton)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAdjustImage" {
            let destination = segue.destination as! AdjustImageViewController
            destination.passedImage = userChosenImage
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    
    
}

