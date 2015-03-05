//
//  FaceView.swift
//  Happiness
//
//  Created by Géza Mikló on 04/03/15.
//  Copyright (c) 2015 Géza Mikló. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {

    @IBInspectable
    var lineWidth: CGFloat = 3
    
    @IBInspectable
    var scale: CGFloat = 0.9 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var rotation : CGFloat = 0 {
        didSet {
            transform = CGAffineTransformMakeRotation(rotation)
            setNeedsDisplay()
        }
    }
    
    var smiliness : Double = 0.6 {
        didSet {
            setNeedsDisplay()
        }
    }

    private enum Eye { case Left, Right }
    
    @IBInspectable
    var faceColor: UIColor = UIColor.redColor()

    var faceCenter : CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    var eyeRadius : CGFloat {
        return faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
    }
    
    var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        println("Drawing")
        // Drawing code
        faceColor.setStroke()
        
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        facePath.stroke()
        
        let leftEyePath = bezierPathForEye(.Left)
        leftEyePath.stroke()
        
        let rightEyePath = bezierPathForEye(.Right)
        rightEyePath.stroke()
        
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
    }
    
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath {
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        
        switch whichEye {
        case .Left:
            eyeCenter.x -= eyeHorizontalSeparation / 2
        case .Right:
            eyeCenter.x += eyeHorizontalSeparation / 2
        }
        
        let eyePath = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        eyePath.lineWidth = lineWidth
        return eyePath;
    }
    
    private func bezierPathForSmile(fractionOfMaxSmile: Double) -> UIBezierPath {
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        
        return path
    }
    
    func onPinched(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .Changed:
            scale = gesture.scale * scale
            gesture.scale = 1
        default:
            break
        }
    }
    
    func onRotate(gesture: UIRotationGestureRecognizer) {
        switch gesture.state {
        case .Changed:
            rotation += gesture.rotation
            gesture.rotation = 0
        default:
            break
        }
    }

}
