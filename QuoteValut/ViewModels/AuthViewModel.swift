import Foundation
import Supabase
import Combine

@MainActor
final class AuthViewModel: ObservableObject {

    // MARK: - Published State
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    @Published var userId: UUID?

    // MARK: - Supabase Client
    private let client = SupabaseManager.shared.client

    // MARK: - Init
    init() {
        Task {
            await checkSession()
        }
    }

    // MARK: - Session Check
    func checkSession() async {
        do {
            let session = try await client.auth.session
            isAuthenticated = true
            userId = session.user.id
        } catch {
            isAuthenticated = false
            userId = nil
        }
    }

    // MARK: - Login
    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            try await client.auth.signIn(
                email: email,
                password: password
            )

            let session = try await client.auth.session
            userId = session.user.id
            isAuthenticated = true

        } catch {
            errorMessage = error.localizedDescription
            isAuthenticated = false
        }

        isLoading = false
    }

    // MARK: - Signup
    func signup(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            try await client.auth.signUp(
                email: email,
                password: password
            )

            let session = try await client.auth.session
            userId = session.user.id
            isAuthenticated = true

        } catch {
            errorMessage = error.localizedDescription
            isAuthenticated = false
        }

        isLoading = false
    }

    // MARK: - Logout
    func logout() async {
        do {
            try await client.auth.signOut()
            isAuthenticated = false
            userId = nil
        } catch {
            print("Logout failed: \(error)")
        }
    }
}
