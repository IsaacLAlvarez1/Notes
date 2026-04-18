//
//  NotesApp.swift
//  Notes
//
//  Created by Isaac L. Alvarez on 4/18/26.
//
import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
    }
}
@main
struct NotesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var notes = NotesViewModel()
    @StateObject var auth = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(auth)
                .environmentObject(notes)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        Group {
            if auth.userSession == nil {
                AuthView()
            } else {
                ContentView()
            }
        }
    }
}
