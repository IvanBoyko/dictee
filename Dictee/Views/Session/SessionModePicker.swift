import SwiftUI

/// Full-screen mode picker presented before starting any session.
/// Both options are visually equal — no option is highlighted over the other.
/// Used by HomeView (regular word-list sessions) and RevisitSessionView.
struct SessionModePicker: View {
    @Environment(\.dismiss) private var dismiss

    /// Primary heading shown in the centre of the screen (e.g. "Liste du 14 avril 2026"
    /// or "Revisit · 3 words").
    let heading: String
    let onTyped: () -> Void
    let onPaper: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 8) {
                    Text(heading)
                        .font(.title2.weight(.semibold))
                        .multilineTextAlignment(.center)
                    Text("How do you want to practise?")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                VStack(spacing: 12) {
                    modeButton("Type your answers", icon: "keyboard", action: onTyped)
                    modeButton("Write on paper",    icon: "pencil.and.outline", action: onPaper)
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func modeButton(_ label: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(label, systemImage: icon)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(.blue.opacity(0.12))
                .foregroundStyle(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}
