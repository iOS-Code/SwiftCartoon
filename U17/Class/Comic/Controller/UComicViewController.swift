//
//  UComicViewController.swift
//  U17
//
//  Created by 岳琛 on 2018/11/8.
//  Copyright © 2018 NJTU-Engineering. All rights reserved.
//  漫画详情页 漫画分类页点击漫画进入

import UIKit
import MBProgressHUD

protocol UComicViewWillEndDraggingDelegate: class {
    func comicWillEndDragging(_ scrollView: UIScrollView)
}

class UComicViewController: UBaseViewController {
    
    private var comicid: Int = 0
    
    private lazy var mainScrollView: UIScrollView = {
        let sw = UIScrollView()
        sw.delegate = self
        sw.isScrollEnabled = false
        return sw
    }()
    
    private lazy var detailVC: UDetailViewController = {
        let dc = UDetailViewController()
        dc.delegate = self
        return dc
    }()
    
    private lazy var chapterVC: UChapterViewController = {
        let cc = UChapterViewController()
        cc.delegate = self
        return cc
    }()
    
    private lazy var navigationBarY: CGFloat = {
        return navigationController?.navigationBar.frame.maxY ?? 0
    }()
    
    private lazy var commentVC: UCommentViewController = {
        let cc = UCommentViewController()
        cc.delegate = self
        return cc
    }()
    
//    private lazy var pageVC: UPageViewController = {
//        return UPageViewController(titles: ["详情", "目录", "评论"],
//                                   vcs: [detailVC, chapterVC, commentVC],
//                                   pageStyle: .topTabBar)
//    }()
    
    private lazy var collectionBtn: UIButton = {
        let bt = UIButton(frame:.zero)
        bt.setBackgroundImage(UIImage.init(named: "nav_bg"), for: UIControlState.normal)
        bt.adjustsImageWhenHighlighted = true
        bt.setTitle("收藏", for: UIControlState.normal)
        bt.setTitle("已收藏", for: UIControlState.selected)
        bt.addTarget(self, action: #selector(collectionButtonAction), for: UIControl.Event.touchUpInside)
        return bt
    }()
    
    private lazy var headView: UComicHead = {
        return UComicHead(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: navigationBarY + 150))
    }()
    
    private var detailStatic: DetailStaticModel?
    private var detailRealtime: DetailRealtimeModel?
    
    
    convenience init(comicid: Int) {
        self.init()
        self.comicid = comicid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .top
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.changeOrientationTo(landscapeRight: false)
        loadData()
    }
    
    private func showTips(_ name : String) {
        let tips:MBProgressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        tips.mode = MBProgressHUDMode.text
        tips.label.text = name
        tips.removeFromSuperViewOnHide = true
        tips.hide(animated: true, afterDelay: 2)
    }
    
    private func loadData() {
        
        let grpup = DispatchGroup()
        
        grpup.enter()
        ApiLoadingProvider.request(UApi.detailStatic(comicid: comicid),
                                   model: DetailStaticModel.self) { [weak self] (detailStatic) in
                                    self?.detailStatic = detailStatic
                                    self?.headView.detailStatic = detailStatic?.comic
                                    
                                    self?.detailVC.detailStatic = detailStatic
                                    self?.chapterVC.detailStatic = detailStatic
                                    self?.commentVC.detailStatic = detailStatic
                                    
                                    ApiProvider.request(UApi.commentList(object_id: detailStatic?.comic?.comic_id ?? 0,
                                                                         thread_id: detailStatic?.comic?.thread_id ?? 0,
                                                                         page: -1),
                                                        model: CommentListModel.self,
                                                        completion: { [weak self] (commentList) in
                                                            self?.commentVC.commentList = commentList
                                                            grpup.leave()
                                    })
        }
        
        grpup.enter()
        ApiProvider.request(UApi.detailRealtime(comicid: comicid),
                            model: DetailRealtimeModel.self) { [weak self] (returnData) in
                                self?.detailRealtime = returnData
                                self?.headView.detailRealtime = returnData?.comic
                                
                                self?.detailVC.detailRealtime = returnData
                                self?.chapterVC.detailRealtime = returnData
                                
                                grpup.leave()
        }
        
        grpup.enter()
        ApiProvider.request(UApi.guessLike, model: GuessLikeModel.self) { (returnData) in
            self.detailVC.guessLike = returnData
            grpup.leave()
        }
        
        grpup.notify(queue: DispatchQueue.main) {
            self.detailVC.reloadData()
            self.chapterVC.reloadData()
            self.commentVC.reloadData()
        }
    }
    
    override func configUI() {
        view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges).priority(.low)
            $0.top.equalToSuperview()
        }
        
        let contentView = UIView()
        mainScrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().offset(-navigationBarY)
        }
        
        mainScrollView.parallaxHeader.view = headView
        mainScrollView.parallaxHeader.height = navigationBarY + 150
        mainScrollView.parallaxHeader.minimumHeight = navigationBarY
        mainScrollView.parallaxHeader.mode = .fill
        
        let bottomConstant = isIPHONEX ? 34.0 : 0.0
        view.addSubview(collectionBtn)
        collectionBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(0-bottomConstant)
            $0.height.equalTo(44)
        }
        
        // 获取本地数据 判断是否收藏
        self.requestLocalData()
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController?.barStyle(.clear)
        mainScrollView.contentOffset = CGPoint(x: 0, y: -mainScrollView.parallaxHeader.height)
    }
    
    @objc private func collectionButtonAction(sender: UIButton) {
        
        collectionBtn.isSelected = !collectionBtn.isSelected;
        if collectionBtn.isSelected == true {
            self.checkLocalData(false)//收藏
        } else {
            self.checkLocalData(true)//取消收藏
        }
    }
}

extension UComicViewController {
    
    // 检查本地缓存
    private func checkLocalData(_ isCalcel: Bool) {
        if isCalcel == true {
            // 取消收藏
            let currentID: Int = self.comicid
            
            var localDic = UserDefaults.standard.dictionary(forKey: "CollectionData")
            if localDic?.keys.count ?? 0 > 0 {
                localDic?.removeValue(forKey: currentID.description)
                UserDefaults.standard.set(localDic, forKey:"CollectionData")
            }
            self.showTips("已取消")
        } else {
            // 收藏
            let currentID: Int = self.comicid
            let currentName: String = (detailStatic?.comic?.name)!
            let currentType: Bool = true
            let currentDic = ["comic_id":currentID, "name":currentName, "type":currentType] as [String : Any]
            
            // 更新本地缓存
            var localDic = UserDefaults.standard.dictionary(forKey: "CollectionData")
            if localDic?.keys.count ?? 0 > 0 {
                localDic?.updateValue(currentDic, forKey: currentID.description)
                UserDefaults.standard.set(localDic, forKey:"CollectionData")
            } else {
                localDic = [currentID.description:currentDic]
                UserDefaults.standard.set(localDic, forKey:"CollectionData")
            }
            self.showTips("已收藏")
        }
        
        //通知界面更新数据
        NotificationCenter.default.post(name: .UCollectionDataDidChange, object: nil)
    }
    
    
    // 读取本地缓存
    private func requestLocalData() {
        let currentID: Int = self.comicid
        let localDic: [String : Any] = UserDefaults.standard.dictionary(forKey: "CollectionData") ?? [" ":" "]
        
        if localDic.keys.contains(currentID.description) {
            let currentDic:[String : Any] = localDic[currentID.description] as! [String : Any]
            if currentDic.keys.count > 0 {
                let currentType: Bool = currentDic["type"] as! Bool
                collectionBtn.isSelected = currentType
            } else {
                collectionBtn.isSelected = false
            }
        } else {
            collectionBtn.isSelected = false
        }
    }
}

extension UComicViewController: UIScrollViewDelegate, UComicViewWillEndDraggingDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= -scrollView.parallaxHeader.minimumHeight {
            navigationController?.barStyle(.theme)
            navigationItem.title = detailStatic?.comic?.name
        } else {
            navigationController?.barStyle(.clear)
            navigationItem.title = ""
        }
    }
    
    func comicWillEndDragging(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            mainScrollView.setContentOffset(CGPoint(x: 0,
                                                    y: -self.mainScrollView.parallaxHeader.minimumHeight),
                                            animated: true)
        } else if scrollView.contentOffset.y < 0 {
            mainScrollView.setContentOffset(CGPoint(x: 0,
                                                    y: -self.mainScrollView.parallaxHeader.height),
                                            animated: true)
        }
    }
}
