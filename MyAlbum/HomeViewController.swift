//
//  HomeViewController.swift
//  MyAlbum
//
//  Created by Yogesh Rathore on 26/12/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var albumTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Yogesh"
        
        return cell
    }
    
    
}

