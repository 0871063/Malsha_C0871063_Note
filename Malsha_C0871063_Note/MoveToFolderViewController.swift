//
//  MoveToFolderViewController.swift
//  Malsha_C0871063_Note
//
//  Created by Malsha Lambton on 2022-10-30.
//

import UIKit

class MoveToFolderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var originalFolderList : [Folder] = []
    weak var delegate: NoteListViewController?
    var selectedFolder : Folder?
    var selectedNoteList : [Note] = []
    var tes = [String]()
    var folderList : [Folder] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.folderList = originalFolderList
        self.folderList.removeAll(where: {$0.folderId == selectedFolder?.folderId})

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell",
                                                        for: indexPath)
        cell.textLabel?.text = self.folderList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folder = self.folderList[indexPath.row]
        let title = "Move to " + folder.name
        let alert = UIAlertController(title: title, message: "Are you sure ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        let moveAction = UIAlertAction(title: "Move", style: .default) { _ in
            self.moveNotes(folder: folder)
        }
        alert.addAction(cancelAction)
        alert.addAction(moveAction)
        self.present(alert, animated: true)
    }
    
    @IBAction func dismissView(_ sender: UIBarButtonItem) {
        dismissView()
    }
    
    private func moveNotes(folder : Folder){

        if let row = self.originalFolderList.firstIndex(where: {$0.folderId == folder.folderId}) {
            for note in selectedNoteList {
                self.originalFolderList[row].noteList.append(note)
                selectedFolder?.noteList.removeAll(where: {$0.noteId == note.noteId})
            }
            self.originalFolderList[row].noteCount = self.originalFolderList[row].noteList.count
        }

        selectedFolder?.noteCount -= selectedNoteList.count
        
        dismissView()
    }
    
    private func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {

        delegate?.updateFolder(folder: self.selectedFolder!, folderList: self.originalFolderList)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
