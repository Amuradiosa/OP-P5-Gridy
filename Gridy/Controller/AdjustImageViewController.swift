//
//  AdjustImageViewController.swift
//  Gridy
//
//  Created by Ahmad Murad on 02/07/2019.
//  Copyright © 2019 Ahmad Murad. All rights reserved.
//

import UIKit

class AdjustImageViewController: UIViewController, UIGestureRecognizerDelegate {

    var passedImage: UIImage?
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cropImageBoxView: UIView!
    @IBOutlet weak var userChosenImage: UIImageView!
    @IBOutlet weak var gridView: UIImageView!
    
    var initialImageViewOffset = CGPoint()
    
    @IBAction func closeButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func startButton(_ sender: Any) {
        performSegue(withIdentifier: "goToGameViewController", sender: self)
        userChosenImage.transform = .identity
    }
    
    func drawing() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: gridView.frame.width, height: gridView.frame.height))
        let gridDrawer = GridDrawer()
        let image = renderer.image { (ctx) in
            if view.frame.width < view.frame.height {
                let squareDimension = view.frame.width*0.9
                cropImageBoxView.frame = CGRect(x: (view.frame.width - squareDimension)/2, y: (view.frame.height - squareDimension)/2, width: squareDimension, height: squareDimension)
                // passing squareDimension - 1 to protect grid lines from being clipped at the edges
                gridDrawer.drawGrid(context: ctx, squareDimension: squareDimension - 1)
            } else {
                let squareDimension = view.frame.height*0.9
                cropImageBoxView.frame = CGRect(x: (view.frame.width - squareDimension)/2, y: (view.frame.height - squareDimension)/2, width: squareDimension, height: squareDimension)
                // passing squareDimension - 1 to protect grid lines from being clipped at the edges
                gridDrawer.drawGrid(context: ctx, squareDimension: squareDimension - 1)
            }
        }
        gridView.image = image
    }
                
    func cropImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(cropImageBoxView.bounds.size, false, 0)
        cropImageBoxView.drawHierarchy(in: cropImageBoxView.bounds, afterScreenUpdates: true)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return screenShot
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToGameViewController" {
//            let destination = segue.destination as! GameViewController
//            destination.gameImage = cropImage()
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGameViewController" {
                let destination = segue.destination as! GameViewController
                destination.gameImage = cropImage()
            }
    }
    
    func configure() {
        drawing()
        gestureRecognisres()
        rounded(button: startButton)
        userChosenImage.image = passedImage
    }
        
    func gestureRecognisres() {
        let panGestureRecogniser = UIPanGestureRecognizer(target: self, action:#selector(moveImageView(_:)))
        userChosenImage.addGestureRecognizer(panGestureRecogniser)
        let rotationGestureRecogniser = UIRotationGestureRecognizer(target: self, action:#selector(rotateImageView(_:)))
        userChosenImage.addGestureRecognizer(rotationGestureRecogniser)
        let pinchGestureRecogniser = UIPinchGestureRecognizer(target: self, action: #selector(scaleImageView(_:)))
        userChosenImage.addGestureRecognizer(pinchGestureRecogniser)
        panGestureRecogniser.delegate = self
        rotationGestureRecogniser.delegate = self
        pinchGestureRecogniser.delegate = self
    }
        
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view != userChosenImage {
            return false
        }
        if gestureRecognizer is UITapGestureRecognizer
            || otherGestureRecognizer is UITapGestureRecognizer {
            return false
        }
        return true
    }
        
    @objc func moveImageView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: userChosenImage.superview)
        if sender.state == .began {
            initialImageViewOffset = userChosenImage.frame.origin
        }
        let position = CGPoint(x: translation.x + initialImageViewOffset.x - userChosenImage.frame.origin.x, y: translation.y + initialImageViewOffset.y - userChosenImage.frame.origin.y)
        userChosenImage.transform = userChosenImage.transform.translatedBy(x: position.x, y: position.y)
    }
        
    @objc func rotateImageView(_ sender: UIRotationGestureRecognizer) {
        userChosenImage.transform = userChosenImage.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }
        
    @objc func scaleImageView(_ sender: UIPinchGestureRecognizer) {
        userChosenImage.transform = userChosenImage.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
    }
        
    func rounded(button: UIButton) {
            var roundedButton = RoundedButton()
            roundedButton.setButton(button)
            roundedButton.rounded()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    
   
}

    

