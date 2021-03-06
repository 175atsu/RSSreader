//
//  ViewController.swift
//  RSSreader
//
//  Created by 飯野敦博 on 2018/09/10.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let feedUrl = URL(string: "https://news.yahoo.co.jp/pickup/rss.xml")!
    var feedItems = [FeedItem]()
    
    var currentElementName : String! // RSSパース中の現在の要素名
    
    let ITEM_ELEMENT_NAME = "item"
    let TITLE_ELEMENT_NAME = "title"
    let LINK_ELEMENT_NAME   = "link"
    
    func segueToSecondViewController() {
        self.performSegue(withIdentifier: "toSecondViewController", sender: nil)
    }
    
    //セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedItems.count
    }
    
    //セルのテキストを追加
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        let feedItem = self.feedItems[indexPath.row]
        cell.textLabel?.text = feedItem.title
        return cell
    }
    
    //セルがタップされた時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedItem = self.feedItems[indexPath.row]
        UIApplication.shared.open(URL(string: feedItem.url)!, options: [:], completionHandler: nil)
        .performSegue(withIdentifier: "toSecondViewController", sender: nil)
    
        
        
    }
    
    // 初期表示時に必要な処理を設定します。
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parser: XMLParser! = XMLParser(contentsOf: feedUrl)
        parser.delegate = self
        parser.parse()
    }
    
    // メモリーが不足にてインスタンスが破棄される直前に呼ばれます。
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: XMLParserDelegate {
    
    // 解析中に要素の開始タグがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElementName = nil
        if elementName == self.ITEM_ELEMENT_NAME {
            feedItems.append(FeedItem())
        } else {
            currentElementName = elementName
        }
    }
    
    // 開始タグと終了タグでくくられたデータがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.feedItems.count > 0 {
            let lastItem = self.feedItems[self.feedItems.count - 1]
            switch currentElementName {
            case self.TITLE_ELEMENT_NAME:
                let tmpString = lastItem.title
                lastItem.title = (tmpString != nil) ? tmpString! + string : string
            case LINK_ELEMENT_NAME:
                lastItem.url = string
            default: break
            }
        }
    }
    
    // 解析中に要素の終了タグがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElementName = nil
    }
    
    // XML解析終了時に実行されるメソッド
    func parserDidEndDocument(_ parser: XMLParser) {
        tableView.reloadData()
    }
}

class FeedItem {
    var title: String!
    var url: String!
}


