//  GitHubService.swift
//  AgileTvGH
//  Created by MacBook PRO on 05/02/25.

import Foundation

struct User: Codable {
    let login: String
    let avatar_url: String?
}

struct Repository: Codable {
    let name: String
    let language: String?
}

class GitHubService {
    static func fetchUser(username: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "https://api.github.com/users/\(username)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Erro desconhecido"])))
                return
            }

            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    static func fetchRepositories(username: String, completion: @escaping (Result<[Repository], Error>) -> Void) {
        guard let url = URL(string: "https://api.github.com/users/\(username)/repos") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Erro desconhecido"])))
                return
            }

            do {
                let repos = try JSONDecoder().decode([Repository].self, from: data)
                completion(.success(repos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
