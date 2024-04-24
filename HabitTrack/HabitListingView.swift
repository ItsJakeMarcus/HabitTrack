//
//  DestinationListingView.swift
//  HabitTrack
//
//  Created by Jake Maidment on 14/04/2024.
//

import SwiftData
import SwiftUI

struct HabitListingView: View {
    @Environment(\.modelContext) var modelContext
    @Query var habits: [Habit]
    let columns: [GridItem] = [
    GridItem(.flexible()),
    GridItem(.flexible()) ]


    var body: some View {
        
        ScrollView {
            
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(habits) { habit in
                NavigationLink(value: habit) {
                    VStack(alignment: .leading) {
                        ZStack {
                            Rectangle()
                                .fill({
                                        switch habit.color {
                                        case 0://RED
                                            return Color(red: 250.0 / 255.0, green: 24.0 / 255.0, blue: 68.0 / 255.0)
                                        case 1://BLUE
                                            return Color(red: 61.0 / 255.0, green: 90.0 / 255.0, blue: 254.0 / 255.0)
                                        case 2://GREEN
                                            return Color(red: 198.0 / 255.0, green: 255.0 / 255.0, blue: 0.0 / 255.0)
                                        case 3://YELLOW
                                            return Color.yellow
                                        default:
                                            return Color(red: 250.0 / 255.0, green: 24.0 / 255.0, blue: 68.0 / 255.0)
                                        }
                                    }())
                                .cornerRadius(20.0)
                                .frame(width: 170, height: 190)
                                .swipeActions {
                                            Button("Delete", systemImage: "trash", role: .destructive) {
                                                modelContext.delete(habit)
                                            }
                                        }
                            
                            ZStack {
                                //CIRCLE 1
                                Circle().stroke( // 1
                                    Color.black.opacity(0.5),
                                    lineWidth: 12
                                                )
                                    .frame(width: 130, height: 130)
                                
                                //CIRCLE 2
                                Circle()
                                    .trim(from: 0, to: CGFloat(habit.score)/100)
                                    .stroke( // 1
                                    Color.black, style: StrokeStyle(
                                        lineWidth: 12,
                                        lineCap: .round
                                    )
                                    
                                                )
                                    .frame(width: 130, height: 130)
                                    .rotationEffect(.degrees(-90))

                                VStack{
                                    Text("\(habit.score)")
                                    .font(.system(size: 46))
                                        .foregroundStyle(.black)
                                        .bold()
                                        .padding(52)
                                    Text(habit.name)
                                        .font(.system(size: 16))
                                        .bold()
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()

            
        }

        .scrollContentBackground(.hidden)
        .background(Image("DotBack").resizable().edgesIgnoringSafeArea(.all))
        
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
    HabitListingView()
}
