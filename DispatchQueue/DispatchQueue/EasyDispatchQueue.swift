//
//  EasyDispatchQueue.swift
//  DispatchQueue
//
//  Created by Jz D on 2019/7/13.
//  Copyright © 2019 Jz D. All rights reserved.
//

import UIKit



enum ConcurrentQueueCount: Int{
    case `default` = 1
    //默认最小并发数
    
    case global = 4
     //默认全局队列线程并发数
    
    
    case max = 32
    //最大并发数
    
}



class EasyDispatchQueue: NSObject {
    

    
    static let mainThreadQueue = EasyDispatchQueue(queue: DispatchQueue.main)
    static let defaultGlobalQueue = EasyDispatchQueue(DispatchQueue.global(qos: DispatchQoS.QoSClass.default), count: ConcurrentQueueCount.global.rawValue)
    static let lowGlobalQueue = EasyDispatchQueue(DispatchQueue.global(qos: DispatchQoS.QoSClass.utility), count: ConcurrentQueueCount.global.rawValue)


    static let highGlobalQueue = EasyDispatchQueue(DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated), count: ConcurrentQueueCount.global.rawValue)
    static let backGroundGlobalQueue = EasyDispatchQueue(DispatchQueue.global(qos: DispatchQoS.QoSClass.background), count: ConcurrentQueueCount.global.rawValue)
    

    
    let concurrentCount: Int
    private let queue: DispatchQueue
    private let semaphore: DispatchSemaphore
    
    private let seriesQueue = DispatchQueue(label: "com.series.ddd.dd.d")
    
    
    // MARK: - lifycycle

    
    convenience init(queue: DispatchQueue) {
        self.init(queue)
    }

    init(_ queue: DispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default), count: Int = ConcurrentQueueCount.default.rawValue){
        
        self.queue = queue
        var concurrentQueueCount = min(count, ConcurrentQueueCount.max.rawValue)
        concurrentQueueCount = max(concurrentQueueCount, ConcurrentQueueCount.default.rawValue)
        self.concurrentCount = concurrentQueueCount
        semaphore = DispatchSemaphore(value: concurrentQueueCount)
        super.init()

        
    }
    
    // MARK: -  sync && async
    
    func sync(_ block: @escaping ()->Void){
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        queue.sync {
          
            block()
            self.semaphore.signal()
        }
        
    }
    
    
    func async(_ block: @escaping ()->Void){
        seriesQueue.async { 
            _ = self.semaphore.wait(timeout: DispatchTime.distantFuture)
            self.queue.async {
                block()
                self.semaphore.signal()
            }
        }
    }
    
    
}

