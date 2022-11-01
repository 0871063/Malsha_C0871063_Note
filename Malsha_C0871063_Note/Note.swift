//
//  Note.swift
//  Malsha_C0871063_Note
//
//  Created by Malsha Lambton on 2022-10-29.
//

import Foundation

var incrementID = 0
struct Note {
    
    var note : String
    var noteId : Int
    var folderId : Int
    
    init(note: String, folderId : Int) {
        self.note = note
        self.folderId = folderId
        self.noteId = incrementID
        incrementID += 1
    }
}
