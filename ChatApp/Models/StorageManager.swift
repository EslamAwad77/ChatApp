//
//  StorageManager.swift
//  ChatApp
//
//  Created by Laptop World on 29/10/1443 AH.
//

import Foundation
import FirebaseStorage


class StorageManager{
    let storage = Storage.storage().reference()
    
    typealias UploadPictureLocation = (Result<String, Error>) -> Void  // typealise closure
   
    func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureLocation){
        let pathImage = "images/\(fileName)"
       storage.child(pathImage).putData(data, metadata: nil,completion: { (metaData, error) in
           guard error == nil else{
               print("failed to upload data to firebase for pic ")
               completion(.failure(StorageErrors.failedToUpload))
               return
           }
        print(metaData)
        print("test")
           self.storage.child(pathImage).downloadURL{(url, error) in
               guard let url = url else{
                   print("failed to get download url")
                   completion(.failure(StorageErrors.failedToGetDownload))
                   return
               }
               let urlString = url.absoluteString
               print("download url returned \(urlString)")
               completion(.success(urlString))
           }
       })
   }
   
   public enum StorageErrors: Error {
       case failedToUpload
       case failedToGetDownload
       
   }
}
