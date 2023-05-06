//
//  ClipboardVaultApp.swift
//  ClipboardVault
//
//  Created by Jared Biehler on 5/5/23.
//

import SwiftUI
import EncryptedAppStorage

@main
struct ClipboardVaultApp: App {
    @EncryptedAppStorage("ClipboardVaultApp") var storedValue: String?
    @State var textFieldText: String = ""
    
    var body: some Scene {
        MenuBarExtra {
            ScrollView {
                VStack {
                    Form {
                        Section {
                            HStack {
                                TextField("", text: $textFieldText)
                                Button(action: {
                                    saveText()
                                }, label: {
                                    Text("Save")
                                })
                            }
                            .padding(.horizontal)

                        } header: {
                            Text("Type a new value to save:")
                        }
                    }
                    
                    Divider()
                        .padding()
                    
                    Button(action: {
                        copyStoredValueToPasteboard()
                    }, label: {
                        Text("Copy to Clipboard")
                            .padding(.horizontal, 20)
                            .frame(height: 60)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(8)
                            .font(.system(size: 18))
                    })
                    .buttonStyle(.plain)
                    .task {
                        await clearPasteboard()
                    }
    
                    
                    Divider()
                        .padding()
                    
                    Button("Quit") {
                       NSApplication.shared.terminate(nil)
                    }
                }
                .padding()
            }
            .frame(minWidth: 300, idealWidth: 300, maxWidth: 300)
            .frame(minHeight: 260, idealHeight: 260, maxHeight: 260)

        } label: {
            Image(systemName: "lock.laptopcomputer")
        }
        .menuBarExtraStyle(.window)
    }
    
    private func saveText() {
        if (!textFieldText.isEmpty) {
            storedValue = textFieldText
        }
        
        textFieldText = ""
    }
    
    private func copyStoredValueToPasteboard() {
        let pasteBoard = NSPasteboard.general
         
        if (!storedValue!.isEmpty) {
            pasteBoard.clearContents()
            pasteBoard.setString(storedValue!, forType: .string)
            print("Value copied to clipboard")
        }
    }
    
    private func clearPasteboard() async {
        // Delay of 30 seconds (1 second = 1_000_000_000 nanoseconds)
        try? await Task.sleep(nanoseconds: 30_000_000_000)
        
        NSPasteboard.general.clearContents()
        print("Pasteboard has been cleared")
    }
}
