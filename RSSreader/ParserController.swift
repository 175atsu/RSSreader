//
//  path.swift
//  RSSreader
//
//  Created by 飯野敦博 on 2018/09/27.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import Foundation
import UIKit

class ParserController: UIViewController, XMLParserDelegate {
    
    let feedUrl = URL(string: "https://news.yahoo.co.jp/pickup/rss.xml")!
    var feedItems = [FeedItem]()
    
    var currentElementName : String! // RSSパース中の現在の要素名
    
    let ITEM_ELEMENT_NAME = "item"
    let TITLE_ELEMENT_NAME = "title"
    let LINK_ELEMENT_NAME   = "link"
    
    // 解析中に要素の開始タグがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.currentElementName = nil
        if elementName == ITEM_ELEMENT_NAME {
            self.feedItems.append(FeedItem())
        } else {
            currentElementName = elementName
        }
    }
    
    // 開始タグと終了タグでくくられたデータがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.feedItems.count > 0 {
            let lastItem = self.feedItems[self.feedItems.count - 1]
            switch self.currentElementName {
            case TITLE_ELEMENT_NAME:
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
        self.currentElementName = nil
    }
    
}
