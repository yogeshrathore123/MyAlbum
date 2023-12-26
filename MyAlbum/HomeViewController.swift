//
//  HomeViewController.swift
//  MyAlbum
//
//  Created by Yogesh Rathore on 26/12/23.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var albumTableView: UITableView!
    
    var nameArray = [String]()
    var idArray = [UUID]()
    
    var selectedAlbum = ""
    var selectedAlbumId = UUID()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchAlbumData), name: NSNotification.Name(rawValue: "newAlbumData"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToDetailView))
        
        fetchAlbumData()
    }
    
    @objc func fetchAlbumData() {
        
        nameArray.removeAll()
        idArray.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: "name") as? String {
                        self.nameArray.append(name)
                    }
                    
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idArray.append(id)
                    }
                    
                    self.albumTableView.reloadData()
                }
            }
        } catch {
            print("Error during fetch album data")
        }
        
    }
    
    @objc func goToDetailView() {
        performSegue(withIdentifier: "DetailVC", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVC" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.choosenAlbum = selectedAlbum
            detailVC.choosenAlbumId = selectedAlbumId
        }
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAlbum = nameArray[indexPath.row]
        selectedAlbumId = idArray[indexPath.row]
        performSegue(withIdentifier: "DetailVC", sender: nil)
    }
    
    
}

