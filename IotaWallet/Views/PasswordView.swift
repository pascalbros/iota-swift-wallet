//
//  PasswordView.swift
//  IotaWalletApp
//
//  Created by Pasquale Ambrosini on 06/01/22.
//

import SwiftUI

struct PasswordView: View {
    @State var password: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(.black)
                        .frame(width: .infinity, height: 80, alignment: .center)
                    SecureField("Stronghold password", text: $password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.black)
                        .font(.title3)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                }.padding()
                ButtonView(title: "Continue", color: .accentColor) {
                    
                }.disabled(password.count < 3)
                Text("A password is needed in order to unlock the wallet, if it's your first time, add a new one")
                    .padding()
                    .font(.subheadline)
                Spacer()
            }
            .navigationTitle("Enter Password")
            
        }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView()
    }
}
