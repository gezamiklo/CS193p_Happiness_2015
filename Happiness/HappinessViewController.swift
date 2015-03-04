//
//  ViewController.swift
//  Happiness
//
//  Created by Géza Mikló on 04/03/15.
//  Copyright (c) 2015 Géza Mikló. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController {

    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "onPinched:"))
            faceView.addGestureRecognizer(UIRotationGestureRecognizer(target: faceView, action: "onRotate:"))
        }
    }
    
    var happiness : Double = 60 {
        didSet {
            faceView.smiliness = (happiness - 50) / 100
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "onPan:"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Changed:
            happiness += Double(gesture.translationInView(view).y)
            gesture.setTranslation(CGPoint(x: 0,y: 0), inView: view)
        default:
            break
        }
    }


}

