//
//  InterfaceController.swift
//  LucidDreamer WatchKit Extension
//
//  Created by Steven Hyun on 2021-04-30.
//

import WatchKit
import Foundation
import HealthKit
import CoreMotion



class WatchMainController: WKInterfaceController, WKExtendedRuntimeSessionDelegate, MotionRecorderObserver, HealthRecorderObserver{
    
    @IBOutlet weak var startButton: WKInterfaceButton!
    
    private var session: WKExtendedRuntimeSession!
    
    private var text:TextFile = TextFile(filename:"measurements3.txt")
    private let heartRateUnit:HKUnit = HKUnit(from: "count/min")
    
    private var isProcessingFinished:Bool = true
    
    private let WBTB_START_TEXT = "WBTB Start"
    private let WBTB_END_TEXT = "WBTB Cancel"
    
    private var healthRecorder:HealthRecorder = {
        let health = HealthRecorder.getSharedInstance()
        return health
    }()
    
    private var motionRecorder:MotionRecorder = {
        let motion = MotionRecorder.getSharedInstance()
        return motion
    }()
    
    private lazy var df:DateFormatter = {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateformat
    }()
    
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        motionRecorder.addListener(obs: self)
        healthRecorder.addListener(obs: self)
        healthRecorder.requestHealthKitAccess()
    }
    
    @IBAction func startButtonPress() {
        if session == nil{
            session = WKExtendedRuntimeSession()
            session.delegate = self
            session.start(at: Date().addingTimeInterval(6*60*60))
            startButton.setTitle("Started!")
            startButton.setTitle(WBTB_END_TEXT)
            self.presentController(withName: "WBTBNoteController", context: nil)
        }
        else{
            if session?.state == .scheduled{
                session?.invalidate()
                session = nil
                startButton.setTitle(WBTB_START_TEXT)
            }
        }
    }
    
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        
    }
    
    private var motionArray:[MotionData] = []
    private var healthArray:[HKQuantitySample] = []
    
    func newMotionDataArrived(motion: CMAcceleration) {
        
        motionArray.append(MotionData(mag:sqrt((motion.x*motion.x + motion.y*motion.y + motion.z*motion.z)),date:Date()))
        
    }
    
    func healthKitReturnedData(samples: [HKQuantitySample]){
        healthArray.append(contentsOf: samples)
        process()
    }
    
    func process(){
        let n = healthArray.count
        
        var sumy:Double = 0
        var sumx:Double = 0
        var sumxy:Double = 0
        var sumxsquared:Double = 0
        
        for i in 0..<n{
            sumxy += Double(i)*healthArray[i].quantity.doubleValue(for: heartRateUnit)
            sumx += sumx + Double(i)
            sumy += sumy + healthArray[i].quantity.doubleValue(for: heartRateUnit)
            sumxsquared += sumxsquared + Double(i)*Double(i)
            print(healthArray[i].quantity.doubleValue(for: heartRateUnit))
        }
        
        let m:Double = (Double(n)*sumxy - (sumx*sumy))/(Double(n)*sumxsquared - sumx*sumx)
        
        text.appendLine(buf: "heart rate slope: \(m) at time:\(df.string(from:Date()))")
        print("\(m)")
        var ZCMCount:[Double] = [0,0,0,0,0,0,0,0]
        
        let minMinute:Int = Calendar.current.component(.minute, from:motionArray[0].date)
        
        for i in 0..<motionArray.count{
            let minute:Int = Calendar.current.component(.minute, from:motionArray[i].date)
            if(motionArray[i].mag > 0.008){
                ZCMCount[minute-minMinute] = ZCMCount[minute-minMinute] + 1
            }
        }
        
        print(motionArray[0].mag)
        
        let sleep = 0.0033 * (1.06 * ZCMCount[0] + 0.54 * ZCMCount[1] + 0.58 * ZCMCount[2] + 0.76 * ZCMCount[3] + 2.3 * ZCMCount[4] + 0.74 * ZCMCount[5] + 0.67 * ZCMCount[6])
        print("\(sleep)")
        text.appendLine(buf:"sleep value calcualted from motion: \(sleep)")
        
        isProcessingFinished = true
        
    }
    
    func healthKitPermissionDenied() {
        
    }
    
    func healthKitReturnedNothing() {
        process()
    }
    
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("Session started at ",Date())
        
        while(true){
            
            if(isProcessingFinished){
                motionArray.removeAll()
                healthArray.removeAll()
                let difference = extendedRuntimeSession.expirationDate!.timeIntervalSince(Date())
                if difference >= (60*6)+30{
                    record(interval:60*6)
                }
                else{
                    break
                }
            }
            else{
                sleep(10)
            }
            
        }
        
        print("done!")
        
    }
    
    func record(interval:UInt32){
        let startDate = Date()
        motionRecorder.startListening()
        isProcessingFinished = false
        sleep(interval)
        motionRecorder.stopListening()
        healthRecorder.fetchData(startDate: startDate.addingTimeInterval(-10*60), endDate: Date())
    }
    
   
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("Session will soon expire at ",Date())
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        
       
    }
    
    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

}


