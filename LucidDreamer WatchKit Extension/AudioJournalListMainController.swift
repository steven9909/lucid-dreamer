//
//  AudioJournalListMainController.swift
//  LucidDreamer WatchKit Extension
//
//  Created by Steven Hyun on 2021-05-10.
//

import WatchKit

class AudioJournalListMainController: WKInterfaceController, AudioJournalListLoaderEvents, WatchSessionObserver{
    
    


    @IBOutlet weak var interfaceTable: WKInterfaceTable!
    
    private let audioJournalLoader = AudioJournalListLoader()
    
    override func awake(withContext context: Any?) {
        
        audioJournalLoader.addListener(obs: self)
        audioJournalLoader.fetchAudioList()
        
        
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let row:String? = (table.rowController(at: rowIndex) as! JournalListRowController).labelText
        
        guard let row = row else {return}
        
        audioJournalLoader.fetchAudio(filename: row)
    }
    
    func audioFileRequestReturnedError(){
        
    }
    
    func audioFileRequestError(error:Error){
        
    }
    
    func audioListReturned(_ list: [String]) {
        interfaceTable.setNumberOfRows(list.count, withRowType: "row")
        
        for (index,item) in list.enumerated(){
            let row = interfaceTable.rowController(at: index) as! JournalListRowController
            row.label.setText(item)
            row.labelText = item
        }
    }
    
    func audioListReturnedError() {
        
    }
    
    func fileTransferError() {
        
    }
    
    func fileTransferSucceed(url: URL) {
        DispatchQueue.main.async {
            self.pushController(withName: "AudioJournalPlayer", context: url)
        }
    }
    
    
    
}
