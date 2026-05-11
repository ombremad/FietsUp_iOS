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
    case email, password, firstName, lastName, nickname, newPassword, newPasswordConfirmation
  }
  
  var body: some View {
    ZStack {
      Color.Surface.login
        .ignoresSafeArea()

    Form {
      
      TitleLabel()
      
      AppFormSection {
        TextField("loginForm.email", text: $vm.loginForm.email)
          .textContentType(.emailAddress)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled()
          .keyboardType(.emailAddress)
          .submitLabel(.next)
          .focused($focusedField, equals: .email)
          .onSubmit { vm.loginMode == .login
            ? (focusedField = .password)
            : (focusedField = .firstName)
          }
        
        if vm.loginMode == .login {
          SecureField("loginForm.password", text: $vm.loginForm.password)
            .textContentType(.password)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .submitLabel(.go)
            .focused($focusedField, equals: .password)
            .onSubmit { submit() }
        }
      }
      
      if vm.loginMode == .signup {
        AppFormSection {
          TextField("loginForm.firstName", text: $vm.loginForm.firstName)
            .textContentType(.givenName)
            .autocorrectionDisabled()
            .submitLabel(.next)
            .focused($focusedField, equals: .firstName)
            .onSubmit { focusedField = .lastName }
          
          TextField("loginForm.lastName", text: $vm.loginForm.lastName)
            .textContentType(.familyName)
            .autocorrectionDisabled()
            .submitLabel(.next)
            .focused($focusedField, equals: .lastName)
            .onSubmit { focusedField = .nickname }
          
          TextField("loginForm.nickname", text: $vm.loginForm.nickname)
            .textContentType(.nickname)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .submitLabel(.next)
            .focused($focusedField, equals: .nickname)
            .onSubmit { focusedField = .newPassword }
        }
      }
      
      if vm.loginMode == .signup {
        AppFormSection {
          SecureField("loginForm.newPassword", text: $vm.loginForm.newPassword)
            .textContentType(.password)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .submitLabel(.next)
            .focused($focusedField, equals: .newPassword)
            .onSubmit { focusedField = .newPasswordConfirmation }
        
          SecureField("loginForm.newPasswordConfirmation", text: $vm.loginForm.newPasswordConfirmation)
            .textContentType(.password)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .submitLabel(.go)
            .focused($focusedField, equals: .newPasswordConfirmation)
            .onSubmit { submit() }
        }
      }
      
      AppButtonSection {
        
        Button(action: submit) {
          if vm.isLoading { ProgressView() }
          else {
            Text(vm.loginMode == .login ? "loginForm.login" : "loginForm.signup")
          }
        }
        .buttonStyle(AppButton(role: .neutral))
        .disabled(vm.isLoading)
        
        Button {
          vm.toggleMode()
        } label: {
          Text(vm.loginMode == .login ? "loginForm.noAccountYet" : "loginForm.alreadyHaveAnAccount")
        }
        .buttonStyle(AppLabelButton())
        
      }
      .listRowBackground(Color.clear)

    }
    .scrollContentBackground(.hidden)
      
  }
    .animation(.default, value: vm.loginMode)
    .scrollDismissesKeyboard(.interactively)
    .onAppear {
      focusedField = .email
    }
    .errorOverlay()
  }
  
  private func submit() {
    Task { await vm.submit() }
  }
}

#Preview {
  LoginView()
}
