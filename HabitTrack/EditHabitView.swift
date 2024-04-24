//
//  EditHabitView.swift
//  HabitTrack
//
//  Created by Jake Maidment on 17/04/2024.
//

import SwiftUI
import SwiftData

struct EditHabitView: View {
    @Bindable var habit: Habit
    @State private var isAnimatingConfetti = false
    @Environment(\.modelContext) var modelContext
    @State private var showAlert = false
    

    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Spacer()
                        .listRowBackground(Color.clear)
                    Section{
                        TextField("Name", text: $habit.name)
                            .listRowBackground(Color.white)
                    }
                    Section{
                        TextField("Details", text: $habit.details, axis: .vertical)
                            .listRowBackground(Color.white)
                    }
                    Section{
                        Picker("Color", selection: $habit.color) {
                        Text("Red").tag(0)
                        Text("Blue").tag(1)
                        Text("Green").tag(2)
                        Text("Yellow").tag(3)
                        }
                        .pickerStyle(.menu)
                        .listRowBackground(Color.white)
                      }

                }
                .scrollContentBackground(.hidden)
                .background(Image("DotBack").resizable().edgesIgnoringSafeArea(.all))
                
                VStack {
                    Spacer()
                        .frame(height: 10)
                    HStack {
                        Text("Score:  \(habit.score)")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .padding()
                        
                        Button(action: {
                            habit.score += 1
                            self.isAnimatingConfetti = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.isAnimatingConfetti = false
                            }
                        }) {Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color(red: 198.0 / 255.0, green: 255.0 / 255.0, blue: 0.0 / 255.0))
                            
                        }
                        
                        
                        Button(action: {
                            
                            habit.score -= 1
                            
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color(red: 250.0 / 255.0, green: 24.0 / 255.0, blue: 68.0 / 255.0))
                                .padding()
                            
                                .cornerRadius(7)
                        }
                        
                        
                    }
                }
                VStack {
                    Spacer()

                    Button(action: {
                        modelContext.delete(habit)
                        showAlert = true
                    }) {
                        Text("Delete")
                            .foregroundColor(.black)
                            .bold()
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)) // Adjusted padding
                            .background(Color(red: 250.0 / 255.0, green: 24.0 / 255.0, blue: 68.0 / 255.0))
                            .cornerRadius(15) // Adjusted corner radius
                    }

                    .padding()
                    
                        
                          
                    }
                .alert(isPresented: $showAlert) {
                                    Alert(title: Text("Deleted"),
                                          message: Text("Your habit has been deleted."),
                                          dismissButton: .default(Text("Ok")){
                                        
                                        
                                    })
                                }
                                
                
                
                
                if isAnimatingConfetti {
                    ConfettiAnimation()
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
    }
}





struct ConfettiAnimation: View {
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
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
                    self.particle.x += CGFloat.random(in: -20..<100) // Changing the upper figure here increases the randomness of the fall
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
        let screenWidth = UIScreen.main.bounds.width
        let inchInPoints = screenWidth / UIScreen.main.scale
        let offset = inchInPoints * 1
        
        self.x = CGFloat.random(in: (0 - offset)..<screenWidth)
        self.y = CGFloat.random(in: -UIScreen.main.bounds.height..<3)
        self.size = CGFloat.random(in: 5..<14)
        self.color = [.red, .green, .blue, .orange, .yellow].randomElement()!
    }
}



    #Preview {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Habit.self, configurations: config)
            let example = Habit(name: "Example habit", details: "Example details go here and will automatically expand vertically as they are edited.", score: 0)
            return EditHabitView(habit: example)
                .modelContainer(container)
        } catch {
            fatalError("Failed to create model container.")
        }
    }
