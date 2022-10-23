//
//  MotionRecorder.swift
//  LucidDreamer WatchKit Extension
//
//  Created by Steven Hyun on 2021-05-08.
//

import Foundation
import CoreMotion

protocol MotionRecorderObserver{
    func newMotionDataArrived(motion:CMAcceleration)
}

class MotionRecorder{
    private static var recorder:MotionRecorder = MotionRecorder()

    private lazy var motionManager:CMMotionManager = {
        return CMMotionManager()
    }()

    private var notify:MotionRecorderObserver?
    
    private let operationQueue:OperationQueue = {
        let op = OperationQueue()
        op.name = "Motion Recorder Observer Queue"
        op.maxConcurrentOperationCount = 1
        return op
    }()
    
    private init(){
        
    }
    
    public static func getSharedInstance() -> MotionRecorder{
        return recorder
    }
    
    func addListener(obs:MotionRecorderObserver){
        self.notify = obs
    }
    
    func startListening(){
        
        motionManager.deviceMotionUpdateInterval = 0.2
        print("Starting device motion updates")
        motionManager.startDeviceMotionUpdates(to: operationQueue, withHandler: { (motion:CMDeviceMotion?, error:Error?) in
            guard let motion = motion else {return}
            
            self.notify?.newMotionDataArrived(motion: motion.userAcceleration)
        })
    }
    
    func stopListening(){
        motionManager.stopDeviceMotionUpdates()
        operationQueue.cancelAllOperations()
    }
    
    func requestMotionAccess(){
        motionManager.startDeviceMotionUpdates()
        motionManager.stopDeviceMotionUpdates()
    }
}
