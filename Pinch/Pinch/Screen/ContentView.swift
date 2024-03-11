//
//  ContentView.swift
//  Pinch
//
//  Created by Shazeen Thowfeek on 07/03/2024.
//

import SwiftUI

struct ContentView: View {
    //MARK: property
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = CGSize(width: 0, height: 0)
    @State private var isDrawerOpen: Bool = false
    
    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 1
    
    //MARK: function
    
    func resetImageState(){
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
            
        }
    }
    
    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }
    
    //MARK: -content
    
    
    
    var body: some View {
        
        NavigationView{
            ZStack{
                Color.clear
                //MARK: - page image
                Image(currentPage())
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x:imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                //MARK: - 1,TAP GUESTURE
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()){
                                imageScale = 5
                            }
                        }else{
                            resetImageState()
                        }
                    })
                //MARK: - drag guesture
                    .gesture(
                    DragGesture()
                        .onChanged{ value in
                            withAnimation(.linear(duration: 1)){
                                imageOffset = value.translation
                            }
                        }
                        .onEnded{ _ in
                            if imageScale <= 1 {
                              resetImageState()
                            }
                        }
                     )
                    //MARK: - magnification
                    .gesture(
                    MagnificationGesture()
                        .onChanged({ value in
                            withAnimation(.linear(duration: 1)){
                                if imageScale >= 1 && imageScale <= 5 {
                                    imageScale = value
                                }else if imageScale > 5 {
                                    imageScale = 5
                                }
                            }
                        }
                            
                                  )
                        .onEnded({ _ in
                            if imageScale > 5 {
                                imageScale = 5
                            }else if imageScale <= 1 {
                                resetImageState()
                            }
                        })
                    
                    )
            } //: Zstack
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            })
            //MARK: - info panel
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                
                ,alignment: .top
            )
            //MARK: - controls
            .overlay(
                Group {
                    HStack{
                        //scale down
                        Button {
                            //some action
                            withAnimation(.spring()){
                                if imageScale > 1 {
                                    imageScale -= 1
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                            }
                        } label: {
                           ControlImageView(icon: "minus.magnifyingglass")
                        }

                        //reset
                        Button {
                            //some action
                            
                            resetImageState()
                        } label: {
                           ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        //scale up
                        Button {
                            //some action
                            withAnimation(.spring()){
                                if imageScale < 5 {
                                    imageScale += 1
                                    
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                        } label: {
                           ControlImageView(icon: "plus.magnifyingglass")
                        }
                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
                    .padding(.bottom,30)
                ,alignment: .bottom
            )
            //MARK: -drawer
            .overlay(
                HStack(spacing: 12){
                    //MARK: - drawer handle
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundColor(.secondary)
                        .onTapGesture(perform: {
                            withAnimation(.easeOut){
                                isDrawerOpen.toggle()
                            }
                        })
                    //MARK: - thumbnails
                    
                    ForEach(pages){ item in
                        Image(item.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture(perform: {
                                isAnimating = true
                                pageIndex = item.id
                            })
                    }
                    
                    Spacer()
                }//: drawer
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 260)
                    .padding(.top,UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 215)
                ,alignment: .topTrailing
            
            )
        }//: Navigation
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
}
