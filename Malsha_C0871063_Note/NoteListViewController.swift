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
        noteTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? AddNoteViewController {
            nextViewController.delegate = self
            nextViewController.selectedFolder = self.selectedFolder
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
        
        if selectedNoteList.contains(where: {$0.noteId == note.noteId}) {
            cell.infoButton?.setBackgroundImage( UIImage(named: "tick"), for: .normal)
        }else{
            cell.infoButton?.setBackgroundImage( UIImage(named: "info"), for: .normal)
        }
        cell.infoButton?.addTarget(self, action: #selector(infoButtonPressed(sender:)), for: .touchUpInside)

               return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! NoteCell
        
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
        }
        delegate?.updateFolderList(with: selectedFolder!)
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
        let selectedIDs = selectedNoteList.map(\.noteId)
        noteList = noteList.filter { !selectedIDs.contains($0.noteId) }
        selectedNoteList.removeAll()
        noteTableView.reloadData()
    }
    
    @IBAction func moveNotes(_ sender: UIBarButtonItem) {
        selectedNoteList.removeAll()
    }
}

class NoteCell: UITableViewCell {
    @IBOutlet var note : UILabel?
    @IBOutlet var infoButton : UIButton?
}
