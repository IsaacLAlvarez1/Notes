//
//  AuthView.swift
//  Notes
//
//  Created by Codex.
//

import SwiftUI

struct AuthView: View {
    enum Mode: String, CaseIterable, Identifiable {
        case login = "Login"
        case signUp = "Sign Up"

        var id: Self { self }
    }

    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var mode: Mode = .login
    @State private var email = ""
    @State private var password = ""
    @State private var isSubmitting = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Picker("Authentication Mode", selection: $mode) {
                    ForEach(Mode.allCases) { currentMode in
                        Text(currentMode.rawValue).tag(currentMode)
                    }
                }
                .pickerStyle(.segmented)

                VStack(spacing: 14) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)

                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                }

                if !authViewModel.errorMessage.isEmpty {
                    Text(authViewModel.errorMessage)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button(actionTitle) {
                    Task {
                        await submit()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isSubmitting)

                Spacer()
            }
            .padding()
            .navigationTitle("Notes")
        }
    }

    private var actionTitle: String {
        isSubmitting ? "Please Wait..." : mode.rawValue
    }

    private func submit() async {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
            authViewModel.errorMessage = "Enter both an email and password."
            return
        }

        isSubmitting = true
        defer { isSubmitting = false }

        switch mode {
        case .login:
            await authViewModel.signIn(email: trimmedEmail, password: trimmedPassword)
        case .signUp:
            await authViewModel.signUp(email: trimmedEmail, password: trimmedPassword)
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthViewModel())
}
