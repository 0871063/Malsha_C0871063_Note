//
//  NoteListViewController.swift
//  Malsha_C0871063_Note
//
//  Created by Malsha Lambton on 2022-10-29.
//

import UIKit

class NoteListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var moveNoteButton: UIBarButtonItem!
    @IBOutlet weak var deleteNoteButton: UIBarButtonItem!
 
    @IBOutlet weak var editNoteListButton: UIBarButtonItem!
    @IBOutlet weak var noteTableView: UITableView!
    
    weak var delegate: FolderListViewController?
    
    var noteList : [Note] = []
    var selectedNote : Note?
    var selectedFolder : Folder?
    var selectedNoteList : [Note] = []
    var folderList : [Folder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moveNoteButton.isEnabled = false
        deleteNoteButton.isEnabled = false
        if let folder = selectedFolder {
            noteList = folder.noteList
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        selectedNoteList.removeAll()
    }
    @IBAction func editNoteList(_ sender: UIBarButtonItem) {
        
        if moveNoteButton.isEnabled {
            moveNoteButton.isEnabled = false
            deleteNoteButton.isEnabled = false
        }else{
            moveNoteButton.isEnabled = true
            deleteNoteButton.isEnabled = true
        }
    }
    
    func updateNoteList(with note : Note){
        if let row = self.noteList.firstIndex(where: {$0.noteId == note.noteId}) {
            self.noteList[row] = note
  
        } else {
            if note.note != "" {
                noteList.append(note)
            }
        }
        if selectedFolder != nil {
            selectedFolder?.noteCount = noteList.count
            selectedFolder?.noteList = noteList
            
            if let row = self.folderList.firstIndex(where: {$0.folderId == selectedFolder?.folderId}) {
                self.folderList[row] = selectedFolder!
      
            }
        }
        
        noteTableView.reloadData()
    }
    
    func updateFolder(folder : Folder, folderList : [Folder]){
        self.folderList = folderList
        self.selectedFolder = folder
        self.noteList = folder.noteList
        noteTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? AddNoteViewController {
            nextViewController.delegate = self
            nextViewController.selectedFolder = self.selectedFolder
        }
        
        if let folderListController = segue.destination as? MoveToFolderViewController {
            folderListController.delegate = self
            folderListController.selectedFolder = self.selectedFolder
            folderListController.originalFolderList = self.folderList
            folderListController.selectedNoteList = self.selectedNoteList
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell",
                                                 for: indexPath) as! NoteCell
        let note = self.noteList[indexPath.row]
        cell.note?.text = note.note
        cell.infoButton?.tag = indexPath.row
        if selectedNoteList.contains(where: {$0.noteId == note.noteId}) {
            cell.infoButton?.setBackgroundImage( UIImage(named: "tick"), for: .normal)
        }else{
            cell.infoButton?.setBackgroundImage( UIImage(named: "info"), for: .normal)
        }
        cell.infoButton?.addTarget(self, action: #selector(infoButtonPressed(sender:)), for: .touchUpInside)

               return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let note = self.noteList[indexPath.row]
        if let row = self.selectedNoteList.firstIndex(where: {$0.noteId == note.noteId}) {
            self.selectedNoteList.remove(at: row)
        } else {
            self.selectedNoteList.append(note)
        }
        noteTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if selectedFolder != nil {
            selectedFolder?.noteCount = noteList.count
            selectedFolder?.noteList = noteList
            
            if let row = self.folderList.firstIndex(where: {$0.folderId == selectedFolder?.folderId}) {
                self.folderList[row] = selectedFolder!
      
            }
        }
        delegate?.updateFolderList(with: self.folderList)
    }
    
    @objc func infoButtonPressed(sender: UIButton) {
    let buttonNumber = sender.tag
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addNoteView = storyboard.instantiateViewController(withIdentifier: "AddNoteViewController") as! AddNoteViewController
        addNoteView.selectedNote = self.noteList[buttonNumber]
        addNoteView.selectedFolder = self.selectedFolder
        addNoteView.delegate = self
        navigationController?.pushViewController(addNoteView, animated: true)
    }
    
    @IBAction func deleteNotes(_ sender: UIBarButtonItem) {
        if selectedNoteList.count > 0 {
            for note in selectedNoteList {
                noteList.removeAll(where: {$0.noteId == note.noteId})
               
            }
            selectedFolder?.noteList = noteList
            if let row = self.folderList.firstIndex(where: {$0.folderId == selectedFolder?.folderId}) {
                self.folderList[row].noteList = noteList
                self.folderList[row].noteCount = self.folderList[row].noteList.count
            }
            selectedNoteList.removeAll()
            noteTableView.reloadData()
        }else{
            showAlert()
        }
    }
    
    @IBAction func moveNotes(_ sender: UIBarButtonItem) {
        if selectedNoteList.count > 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let folderListController = storyboard.instantiateViewController(withIdentifier: "MoveToFolderViewController") as! MoveToFolderViewController
            folderListController.delegate = self
            folderListController.selectedFolder = self.selectedFolder
            folderListController.originalFolderList = self.folderList
            folderListController.selectedNoteList = self.selectedNoteList
            present(folderListController, animated: true)
//            navigationController?.pushViewController(addNoteView, animated: true)
        }else{
            showAlert()
        }
        selectedNoteList.removeAll()
    }
    
    private func showAlert(){
        
        let alert = UIAlertController(title:"Error" , message:"Please select notes to continue" , preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
        
    }
}

class NoteCell: UITableViewCell {
    @IBOutlet var note : UILabel?
    @IBOutlet var infoButton : UIButton?
}
