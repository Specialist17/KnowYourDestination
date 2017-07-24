//
//  CityPostService.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/18/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth.FIRUser
import FirebaseDatabase


struct CityPostService {
    
    
    
    static func create(for image: UIImage, postedBy: String, postedByName: String, postText: String, tags: [String]) {
        let uuid = UUID().uuidString

        if image != UIImage(named: "add_photo_btn"){
            print("hay imagen")
        } else {
            print("no hay imagen")
        }
        
        let storageRef = Storage.storage().reference().child("cityPosts/images/\(postedBy)/\(uuid).png")

        
        guard let uploadData = UIImagePNGRepresentation(image)
            else {return}
        
        storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            var cityPostAttributes: [String : Any]
            if image != UIImage(named: "add_photo_btn"){
                guard let postImgUrl = metadata?.downloadURL()?.absoluteString
                    else {return}
                
                cityPostAttributes = ["post_text": postText,
                                        "image_url" : postImgUrl,
                                        "posted_by": postedBy,
                                        "posted_by_name": postedByName,
                                        "tags" : tags,
                                        "upvotes" : 0,
                                        "downvotes" : 0]

            } else {
                cityPostAttributes = ["post_text": postText,
                                        "image_url" : "",
                                        "posted_by": postedBy,
                                        "posted_by_name": postedByName,
                                        "tags" : tags,
                                        "upvotes" : 0,
                                        "downvotes" : 0]
            }
            create(values: cityPostAttributes, uid: postedBy)
        }
    }
    
    static func create(values: [String: Any], uid: String) {
        
    
        let cityPostRef = Database.database().reference().child(Constants.DatabaseRef.cityPosts).childByAutoId()
        let cityPostByUserRef = Database.database().reference().child("city_post_by_user").child(uid).childByAutoId()
        
        cityPostRef.setValue(values) { (error, ref) in
            if let err = error {
                assertionFailure(err.localizedDescription)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let cityPost = CityPost(snapshot: snapshot)
            })
            
        }
        
        cityPostByUserRef.setValue(values) { (error, ref) in
            if let err = error {
                assertionFailure(err.localizedDescription)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let cityPost = CityPost(snapshot: snapshot)
            })
            
        }
    }
    
    static func cityPosts(completion: @escaping ([CityPost]) -> Void) {
        let ref = Database.database().reference().child(Constants.DatabaseRef.cityPosts)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            let posts: [CityPost] = snapshot.reversed().flatMap{
                guard let post = CityPost(snapshot: $0)
                    else {return nil}
                
                return post
            }
            
            completion(posts)
        })
    }
}
