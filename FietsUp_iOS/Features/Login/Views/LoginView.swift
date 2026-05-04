//
//  LoginView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import SwiftUI

struct LoginView: View {
  @State private var vm = LoginViewModel()
  @FocusState private var focusedField: Field?

  private enum Field {
    case email, firstName, lastName, nickname, password, passwordConfirmation
  }
  
  var body: some View {
    Form {
      Section {
        TextField("Email", text: $vm.loginForm.email)
          .textContentType(.emailAddress)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled()
          .keyboardType(.emailAddress)
          .submitLabel(.next)
          .focused($focusedField, equals: .email)
          .onSubmit {
            switch vm.loginMode {
              case .login:
                focusedField = .password
              case .signup:
                focusedField = .firstName
            }
          }
        
        if vm.loginMode == .signup {
          TextField("First name", text: $vm.loginForm.firstName)
            .textContentType(.givenName)
            .autocorrectionDisabled()
            .submitLabel(.next)
            .focused($focusedField, equals: .firstName)
            .onSubmit { focusedField = .lastName }
          
          TextField("Last name", text: $vm.loginForm.lastName)
            .textContentType(.familyName)
            .autocorrectionDisabled()
            .submitLabel(.next)
            .focused($focusedField, equals: .lastName)
            .onSubmit { focusedField = .nickname }
          
          TextField("Nickname", text: $vm.loginForm.nickname)
            .textContentType(.nickname)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .submitLabel(.next)
            .focused($focusedField, equals: .nickname)
            .onSubmit { focusedField = .password }
        }
        
        SecureField("Password", text: $vm.loginForm.password)
          .textContentType(vm.loginMode == .login ? .password : .newPassword)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled()
          .submitLabel(.go)
          .focused($focusedField, equals: .password)
          .onSubmit {
            switch vm.loginMode {
              case .login:
                submit()
              case .signup:
                focusedField = .passwordConfirmation
            }
          }

        if vm.loginMode == .signup {
          SecureField("Password confirmation", text: $vm.loginForm.passwordConfirmation)
            .textContentType(.newPassword)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .submitLabel(.go)
            .focused($focusedField, equals: .password)
            .onSubmit { submit() }
        }
      }
      
      Section {
        Button {
          vm.toggleMode()
        } label: {
          Text("Toggle mode")
        }
      }
      
      Section {
        Button(action: submit) {
          if vm.isLoading { ProgressView() }
          else {
            switch vm.loginMode {
              case .login:
                Text("Login")
              case .signup:
                Text("Signup")
            }
          }
        }
        .disabled(vm.isLoading)
      }
    }
    .animation(.default, value: vm.loginMode)
    .scrollDismissesKeyboard(.interactively)
    .onAppear {
      focusedField = .email
    }
  }
  
  private func submit() {
    Task { await vm.submit() }
  }
}

#Preview {
  LoginView()
}
