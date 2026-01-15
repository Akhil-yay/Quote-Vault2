import SwiftUI

struct LoginView: View {

    @EnvironmentObject var authVM: AuthViewModel

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.05, green: 0.2, blue: 0.25)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    inspirationCard
                    loginForm
                }
                .padding()
            }
        }
    }

    // MARK: - Inspiration Card
    private var inspirationCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("DAILY INSPIRATION")
                .font(.caption)
                .foregroundColor(.gray)

            Text("“The only way to have a friend is to be one.”")
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color.teal.opacity(0.6), Color.black],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }

    // MARK: - Login Form
    private var loginForm: some View {
        VStack(alignment: .leading, spacing: 20) {

            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)

                Text("Your curated collection of wisdom is just a sign in away.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            // Email
            VStack(alignment: .leading, spacing: 6) {
                Text("EMAIL ADDRESS")
                    .font(.caption)
                    .foregroundColor(.gray)

                TextField("name@example.com", text: $email)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }

            // Password
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("PASSWORD")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Spacer()

                    Button("Forgot Password?") {
                        // next step
                    }
                    .font(.caption)
                    .foregroundColor(.teal)
                }

                SecureField("••••••••", text: $password)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }

            if let error = authVM.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            signInButton
            footerSection
        }
    }

    // MARK: - Sign In Button
    private var signInButton: some View {
        Button {
            Task {
                await authVM.login(email: email, password: password)
            }
        } label: {
            if authVM.isLoading {
                ProgressView()
                    .tint(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                Text("Sign In")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
        .background(Color.teal)
        .cornerRadius(12)
        .disabled(authVM.isLoading)
    }

    // MARK: - Footer
    private var footerSection: some View {
        HStack {
            Text("Don’t have an account?")
                .foregroundColor(.gray)

            Button("Sign Up") {
                // navigate next
            }
            .foregroundColor(.teal)
        }
        .font(.footnote)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
