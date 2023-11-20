//
//  WebService.swift
//  CryptoCrazy
//
//  Created by Murat Yıldırım on 20.11.2023.
//

import Foundation

class WebService {
  
  func downloadCurrencies(url: URL, completion: @escaping (Result<[Crypto],CryptoError>) -> ()) {
    URLSession.shared.dataTask(with: url) { data, response, error in
      if let _ = error {
        completion(.failure(CryptoError.serverError))
      } else if let data = data {
        let cryptoList = try? JSONDecoder().decode([Crypto].self, from: data)
        if let cryptoList = cryptoList {
          completion(.success(cryptoList))
        } else {
          completion(.failure(CryptoError.parseError))
        }
      }
        
      
    }.resume()
  }
  
}
