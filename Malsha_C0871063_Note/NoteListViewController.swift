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
    override func viewDidLoad() {
        super.viewDidLoad()
        moveNoteButton.isEnabled = false
        deleteNoteButton.isEnabled = false
        
        if let folder = selectedFolder {
            noteList = folder.noteList
        }
        // Do any additional setup after loading the view.
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
                                                        for: indexPath)
        cell.textLabel?.text = self.noteList[indexPath.row].note
               return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addNoteView = storyboard.instantiateViewController(withIdentifier: "AddNoteViewController") as! AddNoteViewController
        addNoteView.selectedNote = self.noteList[indexPath.row]
        addNoteView.selectedFolder = self.selectedFolder
        addNoteView.delegate = self
        navigationController?.pushViewController(addNoteView, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if selectedFolder != nil {
            selectedFolder?.noteCount = noteList.count
            selectedFolder?.noteList = noteList
        }
        delegate?.updateFolderList(with: selectedFolder!)
    }
}

