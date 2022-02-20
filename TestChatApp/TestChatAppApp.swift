import SwiftUI

@main
struct TestChatAppApp: App {
    var body: some Scene {
        WindowGroup {
            ChatView(chat: Chat.sampleChat[0]).environmentObject(chatsViewModel())
        }
    }
}
