import SwiftUI

struct Row<Accessory: View>: View {
    let title: String
    var description: String = ""
    @ViewBuilder let accessory: () -> Accessory
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                Text(description)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
            Group {
                accessory()                
            }
        }
        .padding(.vertical, 16)
    }
}
