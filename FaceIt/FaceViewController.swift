//
//  ViewController.swift
//  FaceIt
//
//  Created by Christian Franco Soares on 29/04/17.
//  Copyright © 2017 Pandunia. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Neutral) {
        didSet {
            updateUI()
        }
    }
    
    private var mouthCurvature = [FacialExpression.Mouth.Frown:-1.0, .Grin:0.5,.Smile:1.0,.Smirk:-0.5,.Neutral:0.0]
    
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed: 0.5,.Furrowed: -0.5,.Normal: 0.0]
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
        
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView, action: #selector(FaceView.changeScale(recognizer:))
            ))
            
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.increaseHappiness)
            )
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.decreaseHappiness)
            )
            sadderSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            updateUI()
        }
    }
    
    @IBAction func toggleEyes(_ sender: UITapGestureRecognizer) {
        if(sender.state == .ended){
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
            
        }
    }
    
    
    func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    private func updateUI() {
        switch expression.eyes {
        case .Open: faceView.eyeOpen = true
        case .Closed: faceView.eyeOpen = false
        case .Squinting: faceView.eyeOpen = false
        }
        faceView.mouthCurvature = mouthCurvature[expression.mouth] ?? 0.0
        faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
    }
   
}

