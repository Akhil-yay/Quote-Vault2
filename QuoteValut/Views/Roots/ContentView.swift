import SwiftUI

struct ContentView: View {

    @StateObject private var authVM = AuthViewModel()

    var body: some View {
        Group {
            if authVM.isAuthenticated {
                MainTabView()
                    .environmentObject(authVM)
            } else {
                LoginView()
                    .environmentObject(authVM)
            }
        }
        .onAppear {
            Task {
                await authVM.checkSession()
            }
        }
    }
}

#Preview {
    ContentView()
}
