//
//  ViewController.swift
//  20171116-ScrollView
//
//  Created by Iyuka on 2017/11/16.
//  Copyright © 2017年 Iyuka. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    var currentImageView = UIImageView()
    var pinchStartImageView = UIImageView()
    var pinchCenter = CGPoint()

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
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchAction(_:)))
        pinchGesture.delegate = self
        imageView.addGestureRecognizer(pinchGesture)
    }
    
    func gestureRecognizer(ssgestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func panAction(_ gesture: UIPanGestureRecognizer) {
        let transform = imageView.transform
        imageView.transform = CGAffineTransform.identity
        
        let point: CGPoint = gesture.translation(in: imageView)
        let movedPoint = CGPoint(x: imageView.center.x + point.x,
                                 y: imageView.center.y + point.y)
        print("pan: \(point.x) , \(point.y)")
        
        imageView.center = movedPoint
        
        imageView.transform = transform
        
        gesture.setTranslation(CGPoint.zero, in: imageView)
    }
    
    @objc func pinchAction(_ gesture:UIPinchGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began {
            currentImageView.transform = imageView.transform
            
            // 開始時点の画像の中心点を保存
            pinchStartImageView.center = imageView.center
            
            // ２本の指の接点を保存
            let touchPoint1 = gesture.location(ofTouch: 0, in: imageView)
            let touchPoint2 = gesture.location(ofTouch: 1, in: imageView)
            
            // 指の中間点を求め保存
            pinchCenter = CGPoint.init(x: (touchPoint1.x + touchPoint2.x)/2,
                                       y: (touchPoint1.y + touchPoint2.y)/2)
            
            
            print("pinch start: x\(pinchStartImageView.center.x) , y\(pinchStartImageView.center.y) \n 1\(touchPoint1) , 2\(touchPoint2) \n pC.x \(pinchCenter.x) pC.y \(pinchCenter.y)")
        } else if gesture.state == UIGestureRecognizerState.changed {
            let scale = gesture.scale
            
            let newCenter = CGPoint(x: pinchStartImageView.center.x - ((pinchCenter.x - pinchStartImageView.center.x) * scale - (pinchCenter.x - pinchStartImageView.center.x)),
                                    y: pinchStartImageView.center.y - ((pinchCenter.y - pinchStartImageView.center.y) * scale - (pinchCenter.y - pinchStartImageView.center.y)))
            
            imageView.center = newCenter
            let affine1 = currentImageView.transform
            let affine2 = CGAffineTransform.init(scaleX: scale, y: scale)
            imageView.transform = affine1.concatenating(affine2)

        } else if gesture.state == UIGestureRecognizerState.ended {
            let currentScale = sqrt(abs(imageView.transform.a * imageView.transform.d - imageView.transform.b * imageView.transform.c))
            if currentScale < 1.0 {
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    
                    self.imageView.center = CGPoint(x: (self.imageView.frame.size.width / 2),
                                                    y: (self.imageView.frame.size.height / 2))
                    self.imageView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                }, completion: {(finished: Bool) -> Void in
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

