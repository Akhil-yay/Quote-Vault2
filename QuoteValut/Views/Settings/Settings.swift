import SwiftUI

struct SettingsView: View {

    @EnvironmentObject var authVM: AuthViewModel
    @State private var selectedTheme: ThemeOption = .dark
    @State private var accentColor: Color = .teal
    @State private var fontSize: Double = 16
    @State private var dailyInspiration: Bool = true
    @AppStorage("notifyHour") private var notifyHour = 8
    @AppStorage("notifyMinute") private var notifyMinute = 30
    @AppStorage("dailyNotificationEnabled") private var dailyNotificationEnabled = true
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {
                    header
                    profileSection
                    appearanceSection
                    notificationSection
                    accountSection
                    logoutButton
                    footer
                }
                .padding()
            }
        }
    }

    // MARK: - Header
    private var header: some View {
        HStack {

            Spacer()

            Text("SETTINGS")
                .foregroundColor(.white)
                .fontWeight(.semibold)

            Spacer()

        }
    }

    // MARK: - Profile
    private var profileSection: some View {
        VStack(spacing: 12) {

            ZStack(alignment: .bottomTrailing) {
                Image("profile_placeholder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())

                Circle()
                    .fill(Color.teal)
                    .frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: "pencil")
                            .font(.caption)
                            .foregroundColor(.white)
                    )
            }

            Text("Julian Thorne")
                .foregroundColor(.white)
                .font(.title3)
                .fontWeight(.semibold)

            Text("julian.thorne@design.co")
                .foregroundColor(.gray)
                .font(.footnote)
        }
    }

    // MARK: - Appearance
    private var appearanceSection: some View {
        settingsCard {
            VStack(alignment: .leading, spacing: 16) {

                sectionTitle("APPEARANCE")

                VStack(alignment: .leading, spacing: 8) {
                    Text("Theme").foregroundColor(.white)

                    HStack {
                        themeButton(.light)
                        themeButton(.dark)
                        themeButton(.system)
                    }
                }

                Divider().background(Color.gray.opacity(0.3))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Accent Color").foregroundColor(.white)

                    HStack(spacing: 14) {
                        ForEach(accentColors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 28, height: 28)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: accentColor == color ? 2 : 0)
                                )
                                .onTapGesture {
                                    accentColor = color
                                }
                        }
                    }
                }

                Divider().background(Color.gray.opacity(0.3))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Font Size").foregroundColor(.white)

                    Text("“The only way to do great work is to love what you do.”")
                        .font(.system(size: fontSize))
                        .foregroundColor(.white)

                    Slider(value: $fontSize, in: 12...22)
                }
            }
        }
    }

    // MARK: - Notifications
    private var notificationSection: some View {
        settingsCard {
            VStack(alignment: .leading, spacing: 16) {

                sectionTitle("NOTIFICATIONS")

                Toggle(isOn: $dailyInspiration) {
                    VStack(alignment: .leading) {
                        Text("Daily Inspiration")
                            .foregroundColor(.white)
                        Text("Receive a hand-picked quote every morning.")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: .teal))

                HStack {
                    Text("Delivery Time")
                        .foregroundColor(.white)

                    Spacer()

                    Text("08:30 AM")
                        .foregroundColor(.yellow)
                }
            }
        }
    }

    // MARK: - Account
    private var accountSection: some View {
        settingsCard {
            VStack(spacing: 16) {
                sectionTitle("ACCOUNT & SYNC")

                settingsRow("Cloud Sync", trailing: "ACTIVE", trailingColor: .green)
                settingsRow("Privacy Policy")
                settingsRow("Terms of Service")
            }
        }
    }

    // MARK: - Logout
    private var logoutButton: some View {
        Button {
            Task { await authVM.logout() }
        } label: {
            Text("LOGOUT")
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white.opacity(0.08))
                .cornerRadius(14)
        }
    }

    // MARK: - Footer
    private var footer: some View {
        VStack(spacing: 4) {
            Text("QUOTVAULT V2.4.1")
                .foregroundColor(.gray)
                .font(.caption2)

            Text("Made with heart for thinkers & dreamers.")
                .foregroundColor(.gray)
                .font(.caption2)
        }
    }

    // MARK: - Helpers
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.gray)
    }

    private func themeButton(_ option: ThemeOption) -> some View {
        Text(option == .light ? "LIGHT" : option == .dark ? "DARK" : "SYSTEM")
            .font(.caption)
            .foregroundColor(selectedTheme == option ? .white : .gray)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(selectedTheme == option ? Color.teal : Color.white.opacity(0.05))
            )
            .onTapGesture {
                selectedTheme = option
            }
    }

    private func settingsRow(
        _ title: String,
        trailing: String? = nil,
        trailingColor: Color = .gray
    ) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.white)

            Spacer()

            if let trailing {
                Text(trailing)
                    .foregroundColor(trailingColor)
                    .font(.caption)
            } else {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
    }

    private func settingsCard<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .padding()
            .background(Color.white.opacity(0.06))
            .cornerRadius(16)
    }
}

// MARK: - Supporting Types (OUTSIDE VIEW)
enum ThemeOption {
    case light, dark, system
}

let accentColors: [Color] = [.teal, .yellow, .pink, .green, .purple]

#Preview {
    SettingsView()
}
