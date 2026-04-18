//
//  NoteDetail.swift
//  Notes
//
//  Created by Isaac L. Alvarez on 4/18/26.
//
import SwiftUI
struct NoteDetail: View {
    @Binding var note: NoteModel
    @EnvironmentObject var notesvm: NotesViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("Title", text: $note.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            TextEditor(text: $note.content)
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    notesvm.saveData(note: note)
                    note.title = ""
                    note.content = ""
                    dismiss()
                }
            }
        }
    }
}
#Preview {
    NoteDetail(note: .constant(NoteModel(title: "Hello", content: "First Note")))
}
