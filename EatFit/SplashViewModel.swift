//
//  SplashViewModel.swift
//  EatFit
//
//  Created by Abhilash Ghogale on 27/05/25.
//

import Foundation

// MARK: - SplashViewModel
/// ViewModel for SplashView, handles splash logic and navigation timing.
final class SplashViewModel: ObservableObject {
    // Published property to trigger navigation
    @Published var shouldNavigate: Bool = false
    
    private var timer: Timer?
    
    /// Called when the splash screen appears.
    func onAppear() {
        // Debug log for splash start
        print("[DEBUG] SplashViewModel: Splash screen appeared.")
        startTimer()
    }
    
    /// Starts a timer to auto-navigate after a delay.
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            // Debug log for timer completion
            print("[DEBUG] SplashViewModel: Timer completed, navigating.")
            self?.shouldNavigate = true
        }
    }
    
    deinit {
        timer?.invalidate()
        // Debug log for cleanup
        print("[DEBUG] SplashViewModel: Deinitialized and timer invalidated.")
    }
} 