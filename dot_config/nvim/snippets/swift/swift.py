import json

swift = {
    "debug view": {
        "prefix": "snip_debug_view",
        "body": """
import SwiftUI
struct DebugView: View {
    var body: some View {
        Text("Debuging...")
            .onAppear {}
    }
}

#Preview {
    DebugView()
}
""",
    },
    "region": {
        "prefix": "snip_region",
        "body": """
// region:   --- ${1:name}

// endregion: --- ${1:name}
""",
        "description": "region",
    },
    "alert": {
        "prefix": "snip_alert",
        "body": """
struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalidData = AlertItem(title: Text("Server Error"),
                                       message: Text("The data received from the server was invalid. Please contact support."),
                                       dismissButton: .default(Text("OK")))
    
    static let invalidResponse = AlertItem(title: Text("Server Error"),
                                       message: Text("Invalid response from the server. Please try again later or contact support."),
                                       dismissButton: .default(Text("OK")))
    
    static let invalidURL = AlertItem(title: Text("Server Error"),
                                       message: Text("There was an issue connecting to the server. If this persists, please contact support."),
                                       dismissButton: .default(Text("OK")))
    
    static let unableToComplete = AlertItem(title: Text("Server Error"),
                                       message: Text("Unable to complete your request at this time. Please check your internet connection."),
                                       dismissButton: .default(Text("OK")))
}
""",
        "description": "alert",
    },
    "view": {
        "prefix": "snip_vw",
        "body": """
struct ${1:Name}: View {
    var body: some View {
        Text("Hello, World!")
    }
}
""",
        "description": "view",
    },
    "view file": {
        "prefix": "snip_vwf",
        "body": """
import SwiftUI

struct ${1:Name}: View {
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    ${1:Name}()
}
""",
        "description": "view file",
    },
    "view model": {
        "prefix": "snip_vwmf",
        "body": """
import SwiftUI

final class ${1:Name}: ObservableObject {
    @Published var ${varName}
}
""",
        "description": "view model file",
    },
    "valid email": {
        "prefix": "snip_validate_eamil",
        "body": """
import Foundation

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
}
""",
        "description": "validate email",
    },
}

with open("swift.json", "w") as f:
    json.dump(swift, f, indent=2)
