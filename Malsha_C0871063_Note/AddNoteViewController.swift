//
//  AddNoteViewController.swift
//  Malsha_C0871063_Note
//
//  Created by Malsha Lambton on 2022-10-29.
//

import UIKit

class AddNoteViewController: UIViewController {
    @IBOutlet weak var noteTextView: UITextView!
    
    var selectedNote : Note?
    var selectedFolder : Folder?
    weak var delegate: NoteListViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let note = selectedNote {
            noteTextView.text = note.note
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissKeyBoard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if selectedNote != nil {
            selectedNote?.note = noteTextView.text
        }else{
            selectedNote = Note(note: noteTextView.text,folderId: selectedFolder!.folderId)
        }
        delegate?.updateNoteList(with: selectedNote!)
    }


}

