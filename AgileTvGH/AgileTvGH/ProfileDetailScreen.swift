//  ProfileDetailScreen.swift
//  AgileTvGH
//  Created by MacBook PRO on 05/02/25.

import SwiftUI

struct ProfileDetailScreen: View {
    let user: User
    @State private var repositories: [Repository] = []
    @State private var networkError = false

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: user.avatar_url ?? "")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 170, height: 170)
            .clipShape(Circle())

            Text(user.login)
                .font(.system(size: 15))
                .font(.title)
                .bold()
                .padding(.top, 10)
                .padding(.bottom, 10)

            List(repositories, id: \.name) { repo in
                VStack(alignment: .leading) {
                    Text(repo.name)
                        .font(.headline)
                    Text(repo.language ?? "Unknown")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear {
            fetchRepositories()
        }
        .alert("A network error has occurred. Check your Internet connection and try again later.", isPresented: $networkError) {
            Button("OK", role: .cancel) { }
        }
    }

    private func fetchRepositories() {
        GitHubService.fetchRepositories(username: user.login) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let repos):
                    self.repositories = repos
                case .failure:
                    self.networkError = true
                }
            }
        }
    }
}
