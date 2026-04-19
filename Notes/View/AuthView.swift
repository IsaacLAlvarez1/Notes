//
//  AuthView.swift
//  Notes
//
//  Created by Isaac L. Alvarez on 4/18/26.
//
import SwiftUI
struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Picker("Authentication Mode", selection: $authViewModel.authMode) {
                    ForEach(AuthViewModel.AuthMode.allCases) { selectedMode in
                        Text(selectedMode.rawValue).tag(selectedMode)
                    }
                }
                .pickerStyle(.segmented)
                VStack(spacing: 14) {
                    TextField("Email", text: $authViewModel.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                    SecureField("Password", text: $authViewModel.userPassword)
                        .textFieldStyle(.roundedBorder)
                }
                if !authViewModel.errorMessage.isEmpty {
                    Text(authViewModel.errorMessage)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Button(actionTitle) {
                    Task {
                        await authViewModel.submit()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(authViewModel.isLoading)
                Spacer()
            }
            .padding()
            .navigationTitle("Notes Sign In/Up")
        }
    }
    private var actionTitle: String {
        authViewModel.authMode.rawValue
    }
}
#Preview {
    AuthView()
        .environmentObject(AuthViewModel())
}
