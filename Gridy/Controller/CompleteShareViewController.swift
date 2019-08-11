//
//  CompleteShareViewController.swift
//  Gridy
//
//  Created by Ahmad Murad on 11/08/2019.
//  Copyright © 2019 Ahmad Murad. All rights reserved.
//

import UIKit

class CompleteShareViewController: UIViewController {
    
    var gameImage = UIImage()
    var moves = Int()
    var score = Int()
    
    
    @IBOutlet weak var completeImageHolder: UIImageView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func newGameButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let note = "I solved it"
        let image = gameImage
        let items = [note as Any, image as Any]
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = view
        present(activityController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completeImageHolder.image = gameImage
        scoreLabel.text = "You solved the pazzle in \(moves) and scored \(score)"
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
