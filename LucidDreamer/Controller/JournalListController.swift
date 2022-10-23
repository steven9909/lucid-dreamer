//
//  MainMenuController.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-01.
//

import UIKit

class JournalListController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate{
    
 
    @IBOutlet weak var tableView: UITableView!
    
    private var isAudioRecording:Bool = false
    
    private var selectedJournalIndex:Int?
    
    private lazy var audioStackViews: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var journals: [Journal]? = {
        let audioLoader = AudioJournalsLoader()
        let textLoader = TextJournalsLoader()
        var journals:[Journal] = []
        let audioJournals = audioLoader.loadJournalsFromFS()
        let textJournals = textLoader.loadJournalsFromFS()
        var i = 0
        var j = 0
        
    
        for k in 0..<(audioJournals.count) + (textJournals.count){
            if i >= audioJournals.count || j >= textJournals.count{
                journals.append(contentsOf: audioJournals[i..<audioJournals.count])
                journals.append(contentsOf: textJournals[j..<textJournals.count])
                break
            }
            
            if audioJournals[i].date >= textJournals[j].date{
                journals.append(audioJournals[i])
                i += 1
            }
            else{
                journals.append(textJournals[j])
                j += 1
            }
           
        }
        
        return journals
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        // Do any additional setup after loading the view.
    }
    
    
    private func setUpTableView(){
       
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    
    @IBAction func addAudioJournalButtonClicked(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "AudioJournalRecordController")
        viewController.preferredContentSize = CGSize(width:200,height:100)
        (viewController as? AudioJournalRecordController)?.delegate = self
        viewController.modalPresentationStyle = .popover
        viewController.popoverPresentationController?.permittedArrowDirections = .up
        viewController.popoverPresentationController?.delegate = self
        viewController.popoverPresentationController?.sourceView = sender as? UIView
        self.present(viewController,animated:true,completion:nil)
    }
    
    @IBAction func addMessageJournalButtonClicked(_ sender: Any) {
        selectedJournalIndex = nil
        self.performSegue(withIdentifier: "messagePlaySegue", sender: nil)
    }
   
    
    func updateIsAudioRecording(newVal: Bool){
        isAudioRecording = newVal
    }
    
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        if isAudioRecording {
            return false
        }
        else{
            return true
        }
    }
    
    
    
    func addNewJournalToTableView(journal:Journal){
        journals?.insert(journal, at: 0)
        tableView.reloadData()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journals?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedJournalIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        if (journals?[selectedJournalIndex!] as? AudioJournal) != nil {
            self.performSegue(withIdentifier: "audioPlaySegue", sender: nil)
        }
        else if (journals?[selectedJournalIndex!] as? TextJournal) != nil{
            self.performSegue(withIdentifier: "messagePlaySegue", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell",for:indexPath)
        
        cell.textLabel?.text = self.journals?[indexPath.row].url.deletingPathExtension().lastPathComponent
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0{
            cell.backgroundColor = UIColor.clear.withAlphaComponent(0.2)
        }
        else{
            cell.backgroundColor = UIColor.clear
        }
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            journals?[indexPath.row].delete()
            journals?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    @IBAction func unwindToList(sender: UIStoryboardSegue) {}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "audioPlaySegue"{
            if let index = selectedJournalIndex{
                (segue.destination as? AudioJournalPlayController)?.audioJournal = journals?[index] as? AudioJournal
            }
        }
        else if segue.identifier == "messagePlaySegue"{
            (segue.destination as? TextJournalRecordController)?.delegate = self
            if let index = selectedJournalIndex{
                (segue.destination as? TextJournalRecordController)?.textJournal = journals?[index] as? TextJournal
            }
        }
    }
    

}
