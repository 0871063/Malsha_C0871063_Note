//
//  Folder.swift
//  Malsha_C0871063_Note
//
//  Created by Malsha Lambton on 2022-10-29.
//

import Foundation
var incrementFolderID = 0
struct Folder {
    var name : String
    var folderId : Int
    var noteCount : Int
    var noteList = [Note]()
    init(name: String, noteCount: Int, noteList : [Note] = []) {
        self.name = name
        self.folderId = incrementFolderID
        self.noteCount = noteCount
        self.noteList = noteList
        incrementFolderID += 1
    }
}
