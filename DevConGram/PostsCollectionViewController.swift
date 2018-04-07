//
//  PostsCollectionViewController.swift
//  DevConGram
//
//  Created by Antoine Bellanger on 06.04.18.
//  Copyright © 2018 Antoine Bellanger. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostsCollectionViewController: UICollectionViewController, UITextFieldDelegate {
    
    var ref = Database.database().reference()
    
    var posts:[Post] = []
    
    let refreshControl = UIRefreshControl()

    let tapGestureRecognizer = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView?.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(downloadData), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:3/255, green:104/255, blue:55/255, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Downloading posts...")

        navigationController?.navigationBar.tintColor = UIColor(red: 3/255, green: 104/255, blue: 55/255, alpha: 1)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        downloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCollectionViewCell
        
        cell.postImageView.image = UIImage(named: "ray_1")
    
        let post = posts[indexPath.row]
        
        print(post)
        
        getDataFromUrl(url: URL(string: post.image_url)!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                cell.postImageView.image = UIImage(data: data)
            }
        }
        
        cell.emailLabel.text = post.email
        cell.dateLabel.text = post.date
        cell.captionLabel.text = post.caption
        
        cell.emojiView.removeAll()
        
        let emojis = post.emojis
        
        if (emojis?.isEmpty)! {
            cell.emojiView.append("No reaction 🤷🏻‍♂️")
        } else {
            for (k,v) in (Array(emojis!).sorted {$0.1 > $1.1}) {
                cell.emojiView.append("\(k):\(v)")
            }
        }
        
        cell.emojiView.tagFont = UIFont(name: "WorkSans-Light", size: 14)!
        cell.emojiView.layer.cornerRadius = 5
        
        cell.emojiButton.tag = indexPath.row
        cell.emojiButton.addTarget(self, action: #selector(addAnEmoji(_:)), for: .touchUpInside)
        
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let view = UICollectionReusableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 20))
            //do other header related calls or settups
            return view
            
            
        default:  fatalError("Unexpected element kind")
        }
    }
    
    //MARK: Firebase
    
    @objc func downloadData() {
        
        posts.removeAll()
        
        ref.child("/posts").observe(.value) { (snapshot) in
            let postDict = snapshot.value as? [String: AnyObject]
            print(postDict)
            for post in postDict! {
                let value = post.value as? NSDictionary
                print(post.value)
                let newPost = Post(key: post.key, email: value!["email"] as! String, date: value!["published_at"] as! String, image_url: value!["image_url"] as! String, caption: value!["title"] as! String, emojis: value?["emojis"] as? [String: Int] ?? [:])
                self.posts.append(newPost)
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    @objc func addAnEmoji(_ sender: UIButton) {
        
        print("Emoji Index Path", sender.tag)
        
        var emojis = self.posts[sender.tag].emojis
        
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add a reaction !", message: "Add an emoji about the picture !", preferredStyle: .alert)
        alertController.addTextField { (emojiTextField) -> Void in
            emojiTextField.delegate = self //REQUIRED
            emojiTextField.placeholder = "One Emoji at a time !"
            textField = emojiTextField
        }
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            
            if textField.text!.containsOnlyEmoji && textField.text!.isSingleEmoji {
                if emojis![textField.text!] != nil {
                    let value = emojis![textField.text!]
                    emojis![textField.text!] = value! + 1
                    
                    let tempEmojis = emojis
                    emojis?.removeAll()
                    
                    for (k,v) in (Array(tempEmojis!).sorted {$0.1 < $1.1}) {
                        emojis![k] = v
                    }
                } else {
                    emojis![textField.text!] = 1
                    let tempEmojis = emojis
                    emojis?.removeAll()
                    
                    for (k,v) in (Array(tempEmojis!).sorted {$0.1 < $1.1}) {
                        emojis![k] = v
                    }
                }
            }
            
            let post = self.posts[sender.tag]
//            let updatedPost = Post(key: post.key, email: post.email, image_url: post.image_url, caption: post.caption, emojis: emojis!)
            
            let currentRef = Database.database().reference().child("posts").child(post.key)
            currentRef.updateChildValues(["email": post.email, "published_at": post.date, "image_url": post.image_url, "caption": post.caption, "emojis": emojis!])
            
            DispatchQueue.main.async {
                self.posts.removeAll()
                //self.downloadData()
            }
            
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: ImageDownload Async
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    //MARK: Segue
    
    @IBAction func unwindToPostsViewController(_ segue: UIStoryboardSegue) {
        
        posts.removeAll()
//
//        downloadData()
    }
    
}
