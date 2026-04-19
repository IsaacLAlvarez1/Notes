//
//  ContentView.swift
//  Notes
//
//  Created by Isaac L. Alvarez on 4/18/26.
//
import SwiftUI
struct ContentView: View {
    @EnvironmentObject var notesvm: NotesViewModel
    @EnvironmentObject var auth: AuthViewModel
    @State private var newNote = NoteModel(title: "", content: "")
    var body: some View {
        NavigationStack {
            List {
                ForEach($notesvm.notes) { $note in
                    NavigationLink {
                        NoteDetail(note: $note, isNewNote: false)
                    } label: {
                        Text(note.title)
                    }
                }
                Section {
                    NavigationLink {
                        NoteDetail(note: $newNote, isNewNote: true)
                    } label: {
                        Text("Create New Note")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .navigationTitle("My Notes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Logout") {
                        notesvm.clearData()
                        auth.signOut()
                    }
                }
            }
            .task {
                await notesvm.fetchData()
            }
        }
    }
}
#Preview {
    ContentView()
        .environmentObject(NotesViewModel())
        .environmentObject(AuthViewModel())
}
