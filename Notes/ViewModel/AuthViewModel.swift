//
//  AuthViewModel.swift
//  Notes
//
//  Created by Isaac L. Alvarez on 4/18/26.
//
import Foundation
import Combine
import FirebaseAuth
@MainActor
class AuthViewModel: ObservableObject {
    enum AuthMode: String, CaseIterable, Identifiable {
        case signIn = "Sign In"
        case signUp = "Sign Up"
        var id: Self { self }
    }
    @Published var currentUser: FirebaseAuth.User?
    @Published var errorMessage = ""
    @Published var emailAddress = ""
    @Published var userPassword = ""
    @Published var authMode: AuthMode = .signIn
    @Published var isLoading = false
    init() {
        currentUser = Auth.auth().currentUser
    }
    func submit() async {
        errorMessage = ""
        let trimmedEmail = emailAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = userPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
            errorMessage = "Enter both an email and password."
            return
        }
        isLoading = true
        defer { isLoading = false }
        switch authMode {
        case .signIn:
            await signIn(email: trimmedEmail, password: trimmedPassword)
        case .signUp:
            await signUp(email: trimmedEmail, password: trimmedPassword)
        }
    }
    func signIn(email: String, password: String) async {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            currentUser = result.user
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    func signUp(email: String, password: String) async {
        errorMessage = ""
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            currentUser = result.user
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    func signOut() {
        errorMessage = ""
        do {
            try Auth.auth().signOut()
            currentUser = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
