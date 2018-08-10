//
//  ViewController.swift
//  HXLame
//
//  Created by rockerhx@gmail.com on 08/09/2018.
//  Copyright (c) 2018 rockerhx@gmail.com. All rights reserved.
//


import UIKit
import HXLame


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let path = Bundle.main.path(forResource: "input", ofType: "caf"), let url = URL(string: path) else { return }
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last,
              let mp3URL = URL(string: documentPath + "/output.mp3")
        else { return }

        HXLame.coverToMp3(with: url, writeTo: mp3URL) { (outURL) in
            print(outURL)
        }
    }

}

