//
//  GameViewController.swift
//  Gridy
//
//  Created by Ahmad Murad on 05/07/2019.
//  Copyright © 2019 Ahmad Murad. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    var gameImage     = UIImage()
    var imageArray    = [UIImage]()
    var tileViews     = [TileAttributes]()
    var gridLocations = [CGPoint]()
    var intialImageViewOffset = CGPoint()
    var audioPlayer : AVAudioPlayer!
    
    @IBOutlet weak var containingView: UIView!
    @IBOutlet weak var gridView: UIImageView!
    @IBOutlet weak var tilesContainerView: UIView!
    @IBOutlet weak var soundButton: UIButton!
    
    
    
    
    @IBAction func newGameButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func soundButtonPressed(_ sender: Any) {
        soundButton.isSelected = !soundButton.isSelected
    }
    
    @IBAction func peekButtonPressed(_ sender: Any) {
    }
    
    func play(sound: String) {
        let soundURL = Bundle.main.url(forResource: sound, withExtension: "wav")
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: soundURL!)
        } catch {
            print(error)
        }
        audioPlayer.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawing()
        sliceImage(image: gameImage)
        getGridLocations()
    }
    
    func sliceImage(image: UIImage) {
        let imageToSlice = image
        let width = imageToSlice.size.width/4
        let height = imageToSlice.size.height/4
        // Create a scale conversion factor to convert from points to pixles
        let scale = (imageToSlice.scale)
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
        let numberOfTiles            = 16
        let tileSideDimension        = gridView.frame.height / 4
        let tileSideDimensionWithGap = tileSideDimension + 5
        // calculate the number of tiles that can fit across and down in the tile container view
        let columns = Int((tilesContainerView.frame.width / tileSideDimensionWithGap).rounded(.down))
        let rows    = Int((tilesContainerView.frame.height / tileSideDimensionWithGap).rounded(.down))
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
                        let tileRect = CGRect(x: tileXCoordinate, y: tileYCoordinate, width: tileSideDimension, height: tileSideDimension)
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
        sender.view?.superview?.bringSubviewToFront(sender.view!)
        let translation = sender.translation(in: sender.view?.superview)
        if sender.state == .began {
            intialImageViewOffset = (sender.view?.frame.origin)!
        }
        let position = CGPoint(x: translation.x + intialImageViewOffset.x - (sender.view?.frame.origin.x)!, y: translation.y + intialImageViewOffset.y - (sender.view?.frame.origin.y)!)
        let postionInSuperView = sender.view?.convert(position, to: sender.view?.superview)
        sender.view?.transform = (sender.view?.transform.translatedBy(x: position.x, y: position.y))!
        if sender.state == .ended {
            let (nearTile, snapPosition) = isTileNearGrid(droppingPosition: postionInSuperView!)
            let t = sender.view as! TileAttributes
            if nearTile {
                sender.view?.frame.origin = gridLocations[snapPosition]
                if soundButton.isSelected != true {
                    play(sound: "correct")
                }
                if String(snapPosition) == t.accessibilityLabel {
                    t.isTileInCorrectLocation = true
                } else {
                    t.isTileInCorrectLocation = false
                }
            } else {
                sender.view?.frame.origin = t.originalTileLocation
                t.isTileInCorrectLocation = false
                if soundButton.isSelected != true {
                    play(sound: "wrong")
                }
            }
            checkIfGameComplete()
        }
    }
    
    func checkIfGameComplete() {
        if allTilesInCorrectPosition() {
            performSegue(withIdentifier: "goToShare", sender: self)
        }
    }
    func allTilesInCorrectPosition() -> Bool {
        for tile in tileViews {
            if tile.isTileInCorrectLocation == false {
                return false
            }
        }
        return true
    }
    
    func isTileNearGrid(droppingPosition: CGPoint) -> (Bool,Int) {
        for x in 0..<gridLocations.count {
            let gridlocation = gridLocations[x]
            var fromX = droppingPosition.x
            var toX = gridlocation.x
            var fromY = droppingPosition.y
            var toY = gridlocation.y
            if droppingPosition.x > gridlocation.x {
                fromX = gridlocation.x
                toX   = droppingPosition.x
            }
            if droppingPosition.y > gridlocation.y {
                fromY = gridlocation.y
                toY   = droppingPosition.y
            }
            let distance = (fromX - toX) * (fromX - toX) + (fromY - toY) * (fromY - toY)
            let halfTileSideSize = gridView.frame.height / 2
            if distance < halfTileSideSize {
                return(true, x)
            }
        }
        return(false, 50)
    }
    
    func getGridLocations() {
        let width  = gridView.frame.width / 4
        let height = gridView.frame.height / 4
        for y in 0..<4 {
            for x in 0..<4 {
                //UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
                let location            = CGPoint.init(x: CGFloat(x) * width, y: CGFloat(y) * height)
                let locationInSuperview = gridView.convert(location, to: gridView.superview)
                gridLocations.append(locationInSuperview)
                print(gridLocations)
            }
        }
    }
        
    func drawing() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: gridView.frame.width, height: gridView.frame.height))
        let image = renderer.image { (ctx) in
                let squareDimension = gridView.frame.width
                drawGrid(context: ctx, squareDimension: squareDimension)
        }
        gridView.image = image
    }
    
    func drawGrid(context: UIGraphicsImageRendererContext, squareDimension: CGFloat) {
        for row in 0...4 {
            let point = CGPoint(x: CGFloat(row)*(squareDimension/4), y: 0)
            context.cgContext.move(to: point)
            context.cgContext.addLine(to: CGPoint(x: CGFloat(row)*(squareDimension/4), y: squareDimension))
            context.cgContext.strokePath()
        }
        for col in 0...4 {
            let point = CGPoint(x:  0, y:CGFloat(col)*(squareDimension/4))
            context.cgContext.move(to: point)
            context.cgContext.addLine(to: CGPoint(x: squareDimension, y: CGFloat(col)*(squareDimension/4)))
            context.cgContext.strokePath()
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
