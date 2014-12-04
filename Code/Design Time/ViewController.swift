//
//  ViewController.swift
//  Design Time
//
//  Created by Michael on 10/18/14.
//  Copyright (c) 2014 Michael Helmbrecht. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var heartRateMeter: HeartRateMeter?

    override func viewDidLoad() {
        super.viewDidLoad()

        randomize()
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "randomize", userInfo: nil, repeats: true)
    }

    let mean = 80
    let range = 80
    func randomize() {
        heartRateMeter?.heartRate = Int(arc4random_uniform(range+1)+(mean-range/2))
    }

}
