//
//  ReceiveView.swift
//  IotaWalletApp
//
//  Created by Pasquale Ambrosini on 06/01/22.
//

import SwiftUI

struct ReceiveView: View {
    
    @State var address: String? = "atoi1qzqjcfypqa4hwwpr0yw3vn93m4npjaaexhncpwdsu7x4zrj9mtkuyew5hjx"
    
    var body: some View {
        NavigationView {
            VStack {
                if let _address = address {
                    AddressReceiveView(address: _address) {
                        let addr = address!
                        address = nil
                        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                            address = addr
                        }
                    }
                } else {
                    ProgressView()
                }
            }.navigationTitle("Receive")
        }
    }
}

private struct AddressReceiveView: View {
    
    @State var address: String
    var onReload: () -> Void
    
    var body: some View {
        VStack {
            Image(uiImage: Utils.generateQRCode(from: address))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: .infinity, height: 200)
            Text(address)
                .font(.title3)
                .frame(alignment: .center)
                .multilineTextAlignment(.center)
                .padding()
                .contextMenu {
                        Button(action: {
                            UIPasteboard.general.string = address
                        }) {
                            Text("Copy to clipboard")
                            Image(systemName: "doc.on.doc")
                        }
                     }
            ButtonView(title: "Reload", color: .accentColor, onSelected: onReload)
        }
    }
}




struct ReceiveView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiveView().preferredColorScheme(.light)
    }
}
