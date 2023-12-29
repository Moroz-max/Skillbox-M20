//
//  ViewController.swift
//  Skillbox-M20
//
//  Created by Максим Морозов on 26.12.2023.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    
    private let cellID = "cell"
    
    private let persistentontainer = NSPersistentContainer(name: "Skillbox_M20")
    
    private lazy var fetchResultontroller: NSFetchedResultsController<Artist> = {
        let fetchequest = Artist.fetchRequest()
        let sort = UserDefaults.standard.bool(forKey: "sort")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: sort)
        fetchequest.sortDescriptors = [sortDescriptor]
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchequest, managedObjectContext: self.persistentontainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ArtistCell.self, forCellReuseIdentifier: cellID)
        
        persistentontainer.loadPersistentStores { (persistentDescription, error) in
            if let error = error {
                print("Unable to load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            } else {
                do {
                    try self.fetchResultontroller.performFetch()
                } catch {
                    print(error)
                }
            }
        }
        
    }
    
    @IBAction func sortPresed(_ sender: UIBarButtonItem) {
        let sort = UserDefaults.standard.bool(forKey: "sort")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: !sort)
        fetchResultontroller.fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            try self.fetchResultontroller.performFetch()
            tableView.reloadData()
            UserDefaults.standard.set(!sort, forKey: "sort")
            UserDefaults.standard.synchronize()
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func addButtonPresed(_ sender: UIBarButtonItem) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let nextViewController = storyBoard.instantiateViewController(withIdentifier: "addArtistVC") as? AddArtistViewController {
            nextViewController.Artist = Artist.init(entity: NSEntityDescription.entity(forEntityName: "Artist", in: persistentontainer.viewContext)!, insertInto: persistentontainer.viewContext)
            self.present(nextViewController, animated: true)
        }
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultontroller.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultontroller.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let artist = fetchResultontroller.object(at: indexPath)
        let cell = ArtistCell()
        cell.configure(artist)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)  {
        if editingStyle == .delete {
            let artist = fetchResultontroller.object(at: indexPath)
            persistentontainer.viewContext.delete(artist)
            try? persistentontainer.viewContext.save()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   
    
    
    


}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let artist = fetchResultontroller.object(at: indexPath)
                let cell = tableView.cellForRow(at: indexPath) as? ArtistCell
                cell?.configure(artist)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            print("error")
        }
    }
}
