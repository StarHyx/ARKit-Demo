//
//  ViewController.swift
//  arkit-demo
//
//  Created by Han Yixing on 2018/1/14.
//  Copyright © 2018年 Han Yixing. All rights reserved.
//

import UIKit
import ARKit

private let CellIdentifier = "Cell"

class HomeViewController: UITableViewController {
    
    private var options: [Option] = []
    //建立AR场景
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ARKit Demo"
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        
        self.options = [
            Option(title: "生成图形", vc: SimpleShapeViewController.self),
            Option(title: "识别平面", vc: PlaneMapperViewController.self),
            Option(title: "放置模型", vc: PlaneAnchorViewController.self)
        ]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !ARConfiguration.isSupported {
            let alert = UIAlertController(title: "Device Requirement", message: "Sorry, this app only runs on devices that support augmented reality through ARKit.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        
        cell.textLabel?.text = self.options[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vcType = self.options[indexPath.row].vc
        let vc = vcType.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

private struct Option {
    let title: String
    let vc: UIViewController.Type
}
