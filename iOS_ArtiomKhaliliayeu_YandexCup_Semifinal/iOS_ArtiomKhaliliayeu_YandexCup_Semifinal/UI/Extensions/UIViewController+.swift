//
//  UIViewController+.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/4/23.
//

import UIKit

extension UIViewController {
    func shareFile(_ url: URL) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
}
