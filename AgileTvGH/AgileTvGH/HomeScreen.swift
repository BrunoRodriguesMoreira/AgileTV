//  HomeScreen.swift
//  AgileTvGH
//  Created by MacBook PRO on 05/02/25.

import SwiftUI

struct HomeScreen: View {
    @State private var username: String = ""
    @State private var showProfile = false
    @State private var userNotFound = false
    @State private var networkError = false
    @State private var foundUser: User?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack {
                    Text("GitHub Viewer")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.gray.opacity(1.0))
                        .multilineTextAlignment(.center)
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.bottom, 20)

                Spacer()


                TextField("Username", text: $username)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .frame(maxWidth: 350)


                Button(action: searchUser) {
                    Text("Search")
                        .font(.title3) 
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding()
            .alert("User not found. Please enter another name.",
                   isPresented: $userNotFound) {
                Button("OK", role: .cancel) { }
            }
            .alert("A network error has occurred. Check your Internet connection and try again later.",
                   isPresented: $networkError) {
                Button("OK", role: .cancel) { }
            }
            .navigationDestination(isPresented: $showProfile) {
                if let user = foundUser {
                    ProfileDetailScreen(user: user)
                } else {
                    ProfileDetailScreen(user: User(login: "", avatar_url: ""))
                }
            }
        }
    }

    private func searchUser() {
        GitHubService.fetchUser(username: username) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.foundUser = user
                    self.showProfile = true
                case .failure:
                    self.userNotFound = true
                }
            }
        }
    }
}

