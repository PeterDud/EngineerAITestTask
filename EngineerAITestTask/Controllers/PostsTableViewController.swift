//
//  PostsTableViewController.swift
//  EngineerAITestTask
//
//  Created by Peter Dudar  on 26/10/2018.
//  Copyright © 2018 CHI. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController {

    // MARK: - Properties
    var paging: PagingHelper<FetchPostsRequestModel, FetchPostsResponseModel>?
    fileprivate var posts: [Post] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupTableView()
        
        paging?.fetchNext()
    }
    
    // MARK: - Setup
    func setup() {
        paging = PagingHelper(with: FetchPostsRequestModel(with: 0))
        paging?.loadingCallback = { [weak self] (response) in
            guard let responseModel = response else {
                return
            }
            self?.recive(postsResponse: responseModel)
        }
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: PostTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)
    }
    
    func setCountForNavBar(_ count: Int) {
        self.navigationItem.title = "Posts: \(count)"
    }
    
    // Warning: This method could be called not from the main thread
    func recive(postsResponse: FetchPostsResponseModel) {
        if let newPosts = postsResponse.posts {
            self.posts.append(contentsOf: newPosts)
            
            let countOfPosts = self.posts.count
            var paths: [IndexPath] = []
            for index in  countOfPosts - newPosts.count..<countOfPosts {
                paths.append(IndexPath(row: index, section: 0))
            }
            
            DispatchQueue.main.async {
                self.tableView.performBatchUpdates({ [weak self] in
                    self?.tableView.insertRows(at: paths, with: .none)
                    }, completion: { [weak self] (success) in
                        self?.setCountForNavBar(countOfPosts)
                })
            }
        }
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier)
        
        guard let postCell = cell as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        postCell.setupWith(model: posts[indexPath.row])
        
        return postCell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= posts.count - 1 {
            paging?.fetchNext()
        }
    }

}

