//
//  DestinationListingView.swift
//  HabitTrack
//
//  Created by Jake Maidment on 14/04/2024.
//

import SwiftData
import SwiftUI

struct DestinationListingView: View {
    @Environment(\.modelContext) var modelContext
    @Query var destinations: [Destination]
    
    

    var body: some View {
        List {
            ForEach(destinations) { destination in
                NavigationLink(value: destination) {
                    VStack(alignment: .leading) {
                        Text(destination.name)
                        Text("\(destination.score)")
                            .font(.headline)
                            
                        

//                        Text(destination.score)
                    }
                }
            }
            
            .onDelete(perform: deleteDestinations)
            .listRowBackground(
                                    RoundedRectangle(cornerRadius: 8)
                                        .background(.clear)
                                        .foregroundColor(.white)
                                        .opacity(0.4)
                                        .padding(
                                            EdgeInsets(
                                                top: 8,
                                                leading: 10,
                                                bottom: 2,
                                                trailing: 10
                                            )
                                        )
                                )
                                .listRowSeparator(.hidden)
        }
        
        .scrollContentBackground(.hidden)
                    .background(.linearGradient(colors: [.blue, .green], startPoint: .top, endPoint: .bottom))
        
    }


    func deleteDestinations(_ indexSet: IndexSet) {
        for index in indexSet {
            let destination = destinations[index]
            modelContext.delete(destination)
        }
    }
    struct ConfettiView: View {
        @State private var particles: [ConfettiParticle] = []
        
        var body: some View {
            ZStack {
                ForEach(particles) { particle in
                    ConfettiParticleView(particle: particle)
                }
            }
            .onAppear {
                startConfetti()
            }
            .onDisappear {
                stopConfetti()
            }
        }
        
        func startConfetti() {
            particles = []
            
            for _ in 0..<100 {
                let particle = ConfettiParticle()
                particles.append(particle)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.particles.removeAll()
                }
            }
        }
        
        func stopConfetti() {
            particles.removeAll()
        }
    }

    struct ConfettiParticleView: View {
        @State var particle: ConfettiParticle
        
        var body: some View {
            Circle()
                .foregroundColor(particle.color)
                .frame(width: particle.size, height: particle.size)
                .offset(x: particle.x, y: particle.y)
                .animation(.linear(duration: 2))
                .onAppear {
                    withAnimation {
                        self.particle.y += UIScreen.main.bounds.height
                    }
                }
        }
    }

    struct ConfettiParticle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        var color: Color
        
        init() {
            self.x = CGFloat.random(in: 0..<UIScreen.main.bounds.width)
            self.y = CGFloat.random(in: -UIScreen.main.bounds.height..<0)
            self.size = CGFloat.random(in: 5..<15)
            self.color = [.red, .green, .blue, .orange, .yellow].randomElement()!
        }
    }
}

#Preview {
    DestinationListingView()
}
