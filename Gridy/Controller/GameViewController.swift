//
//  GameViewController.swift
//  Gridy
//
//  Created by Ahmad Murad on 05/07/2019.
//  Copyright © 2019 Ahmad Murad. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    var gameImage = UIImage()
    var imageArray = [UIImage]()
    var tileViews = [TileAttributes]()
    
    @IBOutlet weak var containingView: UIView!
    @IBOutlet weak var gridView: UIImageView!
    @IBOutlet weak var tilesContainerView: UIView!
    
    
    
    
    @IBAction func newGameButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sliceImage(image: gameImage)
        
    }
    
    func sliceImage(image: UIImage) {
        let imageToSlice = image
        let width = imageToSlice.size.width/4
        let height = imageToSlice.size.height/4
        // Create a scale conversion factor to convert from points to pixles
        let scale = (imageToSlice.scale)
        var imageArray = [UIImage]()
        for x in 0..<4 {
            for y in 0..<4 {
                UIGraphicsBeginImageContext(CGSize(width: width, height: height))
                let i = imageToSlice.cgImage?.cropping(to: CGRect(x: CGFloat(x)*width*scale, y: CGFloat(y)*height*scale, width: width, height: height))
                let tileImage = UIImage(cgImage: i!)
                imageArray.append(tileImage)
                UIGraphicsEndImageContext()
            }
        }
        createTiles()
    }
    
    func createTiles() {
        let numberOfTiles = 16
        let tileSideDimension = gridView.frame.height / 4
        let tileSideDimensionWithGap = tileSideDimension + 5
        // calculate the number of tiles that can fit across and down in the tile container view
        let columns = Int((tilesContainerView.frame.width / tileSideDimensionWithGap).rounded(.down))
        let rows = Int((tilesContainerView.frame.height / tileSideDimensionWithGap).rounded(.down))
        let numberOfTilesCanFit = columns * rows
        if numberOfTiles > numberOfTilesCanFit {
            print("More tiles than space available")
        } else {
            var imageNumber = 0
            var imagePositionsarray = Array(0...(imageArray.count - 1))
            for y in 0...rows {
                for x in 0...columns {
                    if imageNumber < numberOfTiles {
                        let tileXCoordinate = CGFloat(x) * tileSideDimensionWithGap
                        let tileYCoordinate = CGFloat(y) * tileSideDimensionWithGap
                        let tileRect = CGRect(x: tileXCoordinate, y: tileYCoordinate, width: tileSideDimensionWithGap, height: tileSideDimensionWithGap)
                        let tile = TileAttributes(originalTileLocation: CGPoint(x: tileXCoordinate, y: tileYCoordinate), frame: tileRect, tileGridLocation: imageNumber)
                        containingView.addSubview(tile)
                        let randomNumber = Int.random(in: 0...(imagePositionsarray.count - 1))
                        let imageIndexNumber = imagePositionsarray.remove(at: randomNumber)
                        tile.image = imageArray[imageIndexNumber]
                        tile.isUserInteractionEnabled = true
                        tile.accessibilityLabel = "\(imageIndexNumber)"
                        let panGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(moveImage(_:)))
                        panGestureRecogniser.delegate = self
                        tile.addGestureRecognizer(panGestureRecogniser)
                        tileViews.append(tile)
                    }
                    imageNumber += 1
                }
            }
        }
    }

    @objc func moveImage(_ sender: UIPanGestureRecognizer) {
        
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
