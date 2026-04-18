//
//  AuthViewModel.swift
//  Notes
//
//  Created by Codex.
//

import Foundation
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var errorMessage = ""

    private var authStateHandler: AuthStateDidChangeListenerHandle?

    init() {
        userSession = Auth.auth().currentUser
        authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.userSession = user
        }
    }

    deinit {
        if let authStateHandler {
            Auth.auth().removeStateDidChangeListener(authStateHandler)
        }
    }

    func signIn(email: String, password: String) async {
        errorMessage = ""

        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            userSession = result.user
        } catch {
            errorMessage = userFacingMessage(for: error)
        }
    }

    func signUp(email: String, password: String) async {
        errorMessage = ""

        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            userSession = result.user
        } catch {
            errorMessage = userFacingMessage(for: error)
        }
    }

    func signOut(notesViewModel: NotesViewModel) {
        errorMessage = ""

        do {
            try Auth.auth().signOut()
            notesViewModel.clearData()
            userSession = nil
        } catch {
            errorMessage = userFacingMessage(for: error)
        }
    }

    private func userFacingMessage(for error: Error) -> String {
        guard let errorCode = AuthErrorCode(rawValue: (error as NSError).code) else {
            return error.localizedDescription
        }

        switch errorCode {
        case .wrongPassword, .invalidCredential, .userNotFound, .invalidEmail:
            return "Incorrect email or password."
        case .emailAlreadyInUse:
            return "That email address is already in use."
        case .weakPassword:
            return "Password must be at least 6 characters."
        case .networkError:
            return "Network error. Check your connection and try again."
        default:
            return error.localizedDescription
        }
    }
}
