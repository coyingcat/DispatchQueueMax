//
//  ViewController.swift
//  DispatchQueue
//
//  Created by Jz D on 2019/7/13.
//  Copyright © 2019 Jz D. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    
    
    var count = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func callAsync(_ sender: UIButton) {
        
        let workConcurrentQueue = DispatchQueue(label: "com.ddd.dd.d", attributes: DispatchQueue.Attributes.concurrent)
        let queue = EasyDispatchQueue(workConcurrentQueue, count: 3)
        count = 5
        print("异步:开始...")
        for i in 0...count{
            queue.async {
                print("thread-info: \(Thread.print) 开始执行任务 \(i) ")
                sleep(1)
                
                print("thread-info: \(Thread.print) 结束执行任务 \(i) \n\n")
            }
        }
       print("异步:主线程任务...")

    }
    
    
    
    
    
    
    
    @IBAction func callSync(_ sender: UIButton) {
        let workConcurrentQueue = DispatchQueue(label: "com.ddd.dd.d", attributes: DispatchQueue.Attributes.concurrent)
        
        let queue = EasyDispatchQueue(workConcurrentQueue, count: 1)
        print("同步:开始...")
        count = 5
        for i in 0...count{
            queue.sync{
                print("thread-info: \(Thread.print) 开始执行任务 \(i) ")
                sleep(1)
                
                print("thread-info: \(Thread.print) 结束执行任务 \(i) \n\n")
            }
        }
        print("同步:主线程任务...")
        

        
    }
    

    
    


}



extension Thread {
    static var print: String{
        return "\r⚡️: \(Thread.current)\r" + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r"
    }
}
