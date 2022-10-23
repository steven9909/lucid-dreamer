//
//  TextJournalRecordController.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-03.
//

import UIKit

class TextJournalRecordController: UIViewController, UITextViewDelegate{
    
    public var textJournal:TextJournal?
    private var isNew:Bool = false
    
    @IBOutlet weak var notificationBar: UINavigationBar!
    @IBOutlet weak var textView: UITextView!
    
    public weak var delegate: JournalListController!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationBar.setBackgroundImage(UIImage(), for: .default)
        notificationBar.shadowImage = UIImage()
        notificationBar.isTranslucent = true
        notificationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20),NSAttributedString.Key.foregroundColor : UIColor.white]
        
        textView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        textView.textColor = UIColor.white
        
        textView.delegate = self
        
        if textJournal == nil{
            textJournal = TextJournal.createNewInstance() as? TextJournal
            textView.text = "Enter your journal here!"
            textView.textColor = UIColor.lightGray
            isNew = true
        }
        else{
            textView.text = textJournal?.read()
            isNew = false
        }
        
        backButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)], for: .normal)
        saveButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)], for: .normal)
        
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your journal here!"
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToList", sender: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let saveStatus:Bool? = self.textJournal?.save(text: textView.textColor == UIColor.lightGray ? "" : textView.text)
        if let save = saveStatus{
            if save && isNew && self.textJournal != nil{
                self.delegate.addNewJournalToTableView(journal: self.textJournal! as Journal)
            }
        }
        
        self.performSegue(withIdentifier: "unwindToList", sender: nil)
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
