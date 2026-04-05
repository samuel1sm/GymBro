//
//  FontPreview.swift
//  GymBro
//
//  Font showcase for Typography system
//

import SwiftUI

struct FontPreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                
                // MARK: - Barlow Condensed Section
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Barlow Condensed")
                        .font(.system(.caption))
                        .foregroundStyle(.secondary)
                    
                    Divider()
                    
                    // Hero XL
                    VStack(alignment: .leading, spacing: 4) {
                        Text("56pt Black")
                            .font(.system(.caption2))
                            .foregroundStyle(.secondary)
                        Text("123.5 KG")
                            .font(.heroXL())
                        Text("123.5 KG")
                            .font(.heroXL(true))
                    }
                    
                    // Hero LG
                    VStack(alignment: .leading, spacing: 4) {
                        Text("40pt Black")
                            .font(.system(.caption2))
                            .foregroundStyle(.secondary)
                        Text("PUSH DAY")
                            .font(.heroLG())
                        Text("PUSH DAY")
                            .font(.heroLG(true))
                    }
                    
                    // Display MD
                    VStack(alignment: .leading, spacing: 4) {
                        Text("32pt ExtraBold")
                            .font(.system(.caption2))
                            .foregroundStyle(.secondary)
                        Text("Bench Press")
                            .font(.displayMD())
                        Text("Bench Press")
                            .font(.displayMD(true))
                    }
                    
                    // Heading SM
                    VStack(alignment: .leading, spacing: 4) {
                        Text("24pt Bold")
                            .font(.system(.caption2))
                            .foregroundStyle(.secondary)
                        Text("Working Sets")
                            .font(.headingSM())
                        Text("Working Sets")
                            .font(.headingSM(true))
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // MARK: - Plus Jakarta Sans Section
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Plus Jakarta Sans")
                        .font(.system(.caption))
                        .foregroundStyle(.secondary)
                    
                    Divider()
                    
                    // Nav Title
                    VStack(alignment: .leading, spacing: 4) {
                        Text("17pt SemiBold — Nav Title")
                            .font(.system(.caption2))
                            .foregroundStyle(.secondary)
                        Text("Workouts")
                            .font(.navTitle())
                    }
                    
                    // Label MD
                    VStack(alignment: .leading, spacing: 4) {
                        Text("15pt SemiBold — Label MD")
                            .font(.system(.caption2))
                            .foregroundStyle(.secondary)
                        Text("Start Workout")
                            .font(.labelMD())
                    }
                    
                    // Body MD
                    VStack(alignment: .leading, spacing: 4) {
                        Text("15pt Regular — Body MD")
                            .font(.system(.caption2))
                            .foregroundStyle(.secondary)
                        Text("This exercise targets your chest, shoulders, and triceps.")
                            .font(.bodyMD())
                    }
                    
                    // Body SM
                    VStack(alignment: .leading, spacing: 4) {
                        Text("13pt Medium — Body SM")
                            .font(.system(.caption2))
                            .foregroundStyle(.secondary)
                        Text("3 sets · 10 reps · 90s rest")
                            .font(.bodySM())
                    }
                    
                    // Caption
                    VStack(alignment: .leading, spacing: 4) {
                        Text("12pt Regular — Caption")
                            .font(.system(.caption2))
                            .foregroundStyle(.secondary)
                        Text("Last updated 2 days ago")
                            .font(.caption())
                    }
                    
                    // Micro
                    VStack(alignment: .leading, spacing: 4) {
                        Text("11pt Medium — Micro")
                            .font(.system(.caption2))
                            .foregroundStyle(.secondary)
                        Text("Workout")
                            .font(.micro())
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // MARK: - Real-World Examples
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Real-World Examples")
                        .font(.system(.caption))
                        .foregroundStyle(.secondary)
                    
                    Divider()
                    
                    // Workout Card Example
                    VStack(alignment: .leading, spacing: 8) {
                        Text("PUSH DAY")
                            .font(.heroLG())
                        Text("Build strength in your chest, shoulders, and triceps")
                            .font(.bodyMD())
                            .foregroundStyle(.secondary)
                        Text("45 min · 8 exercises")
                            .font(.bodySM())
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Stats Example
                    HStack(spacing: 24) {
                        VStack(spacing: 4) {
                            Text("185")
                                .font(.heroXL())
                            Text("Max Weight")
                                .font(.bodySM())
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Text("12")
                                .font(.heroXL())
                            Text("PR Count")
                                .font(.bodySM())
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Exercise Detail Example
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Bench Press")
                            .font(.displayMD())
                        
                        Text("Working Sets")
                            .font(.headingSM())
                        
                        HStack {
                            Text("Set 1")
                                .font(.labelMD())
                            Spacer()
                            Text("100 kg × 8")
                                .font(.bodyMD())
                        }
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                        
                        Text("Rest 2-3 minutes between sets")
                            .font(.caption())
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Font Preview")
    }
}

#Preview {
    NavigationStack {
        FontPreview()
    }
}
