//
//  FirstLaunchManager.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-06.
//

import UIKit

class FirstLaunchManager{
    
    private let views:[UIView]
    private let explanations:[String]
    private let root:UIView
    private var index:Int = 0
    private var prepared:Bool = false
    private var explainView:UIImageView?
    private var textExplainView:TypingTextView?
    
    init(for views:[UIView], root rootView:UIView, explanations:[String]){
        self.views = views
        self.root = rootView
        self.explanations = explanations
    }
    
    func isPrepared() -> Bool{
        return prepared
    }
    
    func prepare(){
        if(!prepared){
            prepared = true
            self.root.addDarkView()
            self.root.addSnapshot(of: views[index])
            index += 1
            
            for view in views{
                view.isUserInteractionEnabled = false
            }
            
            DispatchQueue.main.async {
                self.explainView = UIImageView(image: UIImage.animatedImageNamed("ExplainAnimation/final-", duration: 1))
                self.explainView!.contentMode = .scaleAspectFill
                self.explainView!.alpha = 0.0
                self.root.addSubview(self.explainView!)
                
                self.explainView!.translatesAutoresizingMaskIntoConstraints = false
                self.explainView!.bottomAnchor.constraint(equalTo: self.root.bottomAnchor).isActive = true
                self.explainView!.leadingAnchor.constraint(equalTo: self.root.leadingAnchor).isActive = true
                self.explainView!.heightAnchor.constraint(equalTo: self.root.heightAnchor, multiplier: 0.25, constant: 0).isActive = true
                self.explainView!.widthAnchor.constraint(equalTo: self.explainView!.heightAnchor).isActive = true
                
                self.textExplainView = TypingTextView()
                self.textExplainView?.alpha = 0.0
                self.root.addSubview(self.textExplainView!)
                
                
                self.textExplainView!.translatesAutoresizingMaskIntoConstraints = false
                self.textExplainView!.bottomAnchor.constraint(equalTo: self.explainView!.topAnchor, constant: 0).isActive = true
                self.textExplainView!.leadingAnchor.constraint(equalTo: self.root.leadingAnchor, constant: 0).isActive = true
                self.textExplainView!.trailingAnchor.constraint(equalTo: self.root.trailingAnchor, constant: 0).isActive = true
                self.textExplainView!.heightAnchor.constraint(equalTo: self.root.heightAnchor, multiplier: 0.2, constant: 0).isActive = true
                self.textExplainView!.backgroundColor = nil
                self.textExplainView!.textColor = UIColor.white
                self.textExplainView!.isEditable = false
                self.textExplainView!.font = UIFont.init(name: "Marker Felt Thin", size: 22.0)
                self.textExplainView!.isScrollEnabled = true
                
                
                self.explainView!.fadeIn()
                self.textExplainView!.fadeIn { [weak self] in
                    guard let explain = self?.explanations[0],
                          let view = self?.textExplainView else {return}
                    view.typeText(content: explain)
                }
            }
        }
    }
    
    func showNext(){
        if views.count == index{
            self.root.removeSnapshots()
            self.root.removeDarkView()
            self.explainView?.fadeOut(){
                self.explainView?.removeFromSuperview()
            }
            self.textExplainView?.fadeOut(){
                self.textExplainView?.removeFromSuperview()
            }
            index += 1
            
            for view in views{
                view.isUserInteractionEnabled = true
            }
        }
        else if views.count > index{
            self.root.removeSnapshots()
            self.root.addSnapshot(of: views[index],bringForward: self.textExplainView)
            self.textExplainView?.typeText(content: self.explanations[self.index])
            index += 1
        }
    }
    
    
    
    
}
