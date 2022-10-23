//
//  Extensions.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-06.
//

import UIKit
import CoreGraphics

extension UIViewController{
    
    private static var firstLaunch:Bool = false
    
    class func isFirstLaunch() -> Bool{
        #if DEBUG
            return true
        #else
        if let _ = UserDefaults.standard.string(forKey:"appAlreadyLaunched"){
            if(firstLaunch){
                return true
            }
            return false
        } else {
            UserDefaults.standard.setValue(true, forKey:"appAlreadyLaunched")
            firstLaunch = true
            return true
        }
        #endif
    }
}

extension String{
    var htmlToAttributedString: NSAttributedString? {
        
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            return nil
        }
        
    }
}

extension UIView{
    var snapshot: UIImage? {
        
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = renderer.image {ctx in self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)}
        return image
    }
    
    func addSnapshot(of view: UIView, handler: (() -> Void)? = nil,bringForward:UIView? = nil){
        DispatchQueue.main.async{
            guard let snapshot = view.snapshot else { return }
            let imageView = SnapshotView(image:snapshot)
            let gp = self.convert(view.frame.origin, from: view.superview)
            imageView.frame = CGRect(origin:gp, size: view.frame.size)
            self.addSubview(imageView)
            imageView.fadeIn(){
                handler?()
            }
            guard let bringForward = bringForward else {return}
            self.bringSubviewToFront(bringForward)
        }
    }
    
    func removeSnapshots() {
        subviews.filter({ $0 is SnapshotView }).forEach({ (view) in
            view.fadeOut {
                view.removeFromSuperview()
            }
        })
    }
    
    func addDarkView(completion: (() -> Void)? = nil){
        removeDarkView()
        
        DispatchQueue.main.async {
            let dark = DarkView(frame: CGRect(x:0, y:0, width: self.frame.size.width, height: self.frame.size.height))
            dark.backgroundColor = UIColor.black.withAlphaComponent(0.9)
            self.addSubview(dark)
            
            NSLayoutConstraint.activate([dark.topAnchor.constraint(equalTo: self.topAnchor, constant:0),dark.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:0),dark.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:0),dark.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:0)])
            
            dark.fadeIn(){
                completion?()
            }
        }
    }
    
    func removeDarkView(){
        DispatchQueue.main.async {
            for subview in self.subviews {
                if let subview = subview as? DarkView {
                    subview.fadeOut() {
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func fadeIn(completion: (() -> Void)? = nil){
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: 1, animations: {self.alpha = 1}, completion: {_ in completion?()
        })
    }
    
    func fadeOut(completion: (() -> Void)? = nil){
        UIView.animate(withDuration: 1, animations: {self.alpha = 0}, completion: {_ in self.isHidden = true
            completion?()
        })
    }
}


extension String{
    var boolValue:Bool{
        return (self as NSString).boolValue
    }
}

extension StringProtocol{
    subscript(offset: Int) -> Character{
        self[index(startIndex, offsetBy: offset)]
    }
}

class InsetLabel : UILabel{
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}
