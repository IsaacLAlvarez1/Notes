//
//  NoteModel.swift
//  Notes
//
//  Created by Isaac L. Alvarez on 4/18/26.
//
import Foundation
import FirebaseFirestore
struct NoteModel: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var content: String
}
