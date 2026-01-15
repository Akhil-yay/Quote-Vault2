import SwiftUI

@main
struct QuoteVaultApp: App {
    
    @StateObject private var aithVM = AuthViewModel()
    
    init(){
        NotificationManager.shared.requestPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
