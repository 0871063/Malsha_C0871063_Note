//
//  ViewController.swift
//  Malsha_C0871063_Note
//
//  Created by Malsha Lambton on 2022-10-29.
//

import UIKit

class FolderListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var folderListTableView: UITableView!
    
    var folderList : [Folder] = []
    var selectedfolder : Folder?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }

    @IBAction func addFolder(_ sender: Any) {
        let alert = UIAlertController(title: "New Folder", message: "Enter a name for this folder", preferredStyle: .alert)
        alert.addTextField()

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(UIColor.orange, forKey: "titleTextColor")
        let submitAction = UIAlertAction(title: "Add Item", style: .default) { [unowned alert] _ in
            if let answer = alert.textFields![0].text {
                if answer != ""{
                    let folder = Folder(name: answer, noteCount: 0)
                    self.folderList.append(folder)
                }else{
                    let alert = UIAlertController(title: "Error", message: "Folder name cannot be empty", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true)
                }
                self.folderListTableView.reloadData()
            }
        }
        submitAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    @IBAction func editfolderList(_ sender: UIBarButtonItem) {
        if folderListTableView.isEditing {
            folderListTableView.isEditing = false
            editButton.title = "Edit"
        }else{
            folderListTableView.isEditing = true
            editButton.title = "Done"
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldertCell",
                                                        for: indexPath) as! FoldertCell
        cell.name?.text = self.folderList[indexPath.row].name
        cell.count?.text = String(self.folderList[indexPath.row].noteCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let noteListView = storyboard.instantiateViewController(withIdentifier: "NoteListViewController") as! NoteListViewController
        noteListView.selectedFolder = self.folderList[indexPath.row]
        noteListView.delegate = self
        navigationController?.pushViewController(noteListView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            folderList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.folderList[sourceIndexPath.row]
        folderList.remove(at: sourceIndexPath.row)
        folderList.insert(movedObject, at: destinationIndexPath.row)
    }
    
    func updateFolderList(with folder : Folder){
        if let row = self.folderList.firstIndex(where: {$0.folderId == folder.folderId}) {
            self.folderList[row] = folder
  
        }
        folderListTableView.reloadData()
    }    
}

class FoldertCell: UITableViewCell {
    @IBOutlet var name : UILabel?
    @IBOutlet var icon : UIImageView?
    @IBOutlet var count : UILabel?
}

