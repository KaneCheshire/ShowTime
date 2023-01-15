import SwiftUI
import UniformTypeIdentifiers

struct Row<Accessory: View>: View {
    let title: String
    var description: String?
    var codeExample: String?
    @ViewBuilder let accessory: () -> Accessory
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .bold()
                    if let description {
                        Text(description)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Spacer()
                Group {
                    accessory()
                        .labelsHidden()
                }
            }
            .padding(.vertical, 16)
            if let codeExample {
                Group {
                    Text(codeExample)
                        .monospaced()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .textSelection(.enabled)
                .onTapGesture {
                    UIPasteboard.general.setValue(codeExample, forPasteboardType: UTType.utf8PlainText.identifier)
                    NotificationCenter.default.post(name: .init("ShowTime.AddedToPasteboard"), object: nil)
                }
            }
            Divider()
        }
    }
}
