# FreshScrollView
SwiftUI ScrollView can pull to fresh

#### One day, when I were writing a scrollview with a SwiftUI, I suddenly wanted to add a drop-down refresh to it, but soon found that it was too difficult...

### Here is a easy way.

```swift
public struct FreshScrollView<Content>: View where Content : View{
    private let content: () -> Content
    private let action: () -> Void
    
    init(@ViewBuilder content:  @escaping () -> Content, action: @escaping ()-> Void){
        self.content = content
        self.action = action
    }
    
    @State var startY: Double = 10000
    
    public var body: some View{
        ScrollView{
            GeometryReader{ geometry in
                HStack {
                    Spacer()
                    if geometry.frame(in: .global) .minY - startY > 30{
                        ProgressView()
                            .padding(.top, -30)
                            .animation(.easeInOut)
                            .transition(.move(edge: .top))
                            .onAppear{
                                let noti = UIImpactFeedbackGenerator(style: .light)
                                noti.prepare()
                                noti.impactOccurred()
                                action()
                            }
                    }
                    Spacer()
                }
                .onAppear {
                    startY = geometry.frame(in:.global).minY
                }
            }
            content()
        }
    }
}


#if DEBUG
struct FreshScrollView_Previews: PreviewProvider {
    static var previews: some View {
        FreshScrollView {
            Text("A")
            Text("B")
            Text("C")
            Text("D")
        } action: {
            print("text")
        }

    }
}
#endif

```
