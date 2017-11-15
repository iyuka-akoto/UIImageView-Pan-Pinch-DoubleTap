//
//  ViewController.swift
//  20171116-ScrollView
//
//  Created by Iyuka on 2017/11/16.
//  Copyright © 2017年 Iyuka. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.myInit()
    }
    
    func myInit() {
        self.imageView.image = UIImage(named: "20171115_apod.nasa.gov-NGC7789Rose_Seigneuret2048.jpg")
        self.imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.imageView.isUserInteractionEnabled = true
        
        // Pan gesture
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panAction(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        imageView.addGestureRecognizer(panGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func panAction(_ gesture: UIPanGestureRecognizer) {
        let transform = imageView.transform
        imageView.transform = CGAffineTransform.identity
        
        let point: CGPoint = gesture.translation(in: imageView)
        let movedPoint = CGPoint(x: imageView.center.x + point.x,
                                 y: imageView.center.y + point.y)
        imageView.center = movedPoint
        
        imageView.transform = transform
        
        gesture.setTranslation(CGPoint.zero, in: imageView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

