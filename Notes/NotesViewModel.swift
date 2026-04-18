//
//  NotesViewModel.swift
//  Notes
//
//  Created by Isaac L. Alvarez on 4/18/26.
//
import Foundation
import Combine
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class NotesViewModel: ObservableObject {
    @Published var notes: [NoteModel] = []
    let db = Firestore.firestore()

    private var notesCollection: CollectionReference? {
        guard let userID = Auth.auth().currentUser?.uid else {
            return nil
        }

        return db.collection("users").document(userID).collection("notes")
    }

    func fetchData() async {
        notes.removeAll()

        guard let notesCollection else {
            return
        }

        do {
            let querySnapshot = try await notesCollection.getDocuments()
            for document in querySnapshot.documents {
                notes.append(try document.data(as: NoteModel.self))
            }
        } catch {
            print(error)
        }
    }

    func saveData(note: NoteModel) {
        guard let notesCollection else {
            return
        }

        do {
            if !note.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !note.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                if let id = note.id {
                    try notesCollection.document(id).setData(from: note)
                } else {
                    try notesCollection.addDocument(from: note)
                }
            }
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }

    func clearData() {
        notes.removeAll()
    }
}
