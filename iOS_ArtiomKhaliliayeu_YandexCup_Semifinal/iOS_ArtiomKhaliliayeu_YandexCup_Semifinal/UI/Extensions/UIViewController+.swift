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

    func presentSettingsAlert() {
        let alertController = UIAlertController (title: "Нет доступа к микрофону", message: "Для записи аудио вы должны предоставить приложению доступ к микрофону", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Предоставить", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}
