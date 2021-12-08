//
//  SwiftUIFreshControl.swift
//  FreshScrollView
//
//  Created by WeIHa'S on 2021/12/8.
//

import SwiftUI

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
