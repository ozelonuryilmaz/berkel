//
//  InvoicePDFCreator.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.05.2024.
//

import UIKit
import PDFKit

typealias InvoicePDFModel = InvoicePDFCreator.Entry

final class InvoicePDFCreator {
    var entries: [Entry]
    var totalDebit: Double { entries.reduce(0) { $0 + $1.debit } }
    var totalCredit: Double { entries.reduce(0) { $0 + $1.credit } }
    var totalBalance: Double { totalDebit - totalCredit }
    
    struct Entry {
        let uuid: String = UUID().uuidString
        let date: String
        let description: String
        let invoiceNo: String
        let type: EntryType
        var debit: Double
        var credit: Double
        var balance: Double
        
        enum EntryType {
            case collection
            case payment
        }
    }

    init(entries: [Entry]) {
        self.entries = entries
    }

    func createPDF() -> Data {
        let title = "Jobi - \(Date().dateFormatterApiResponseType().dateFormatToAppDisplayNameType() ?? "")"
        let subtitle = "    Gelir Gider Çizelgesi"

        let pdfMetaData = [
            kCGPDFContextCreator: title,
            kCGPDFContextAuthor: title,
            kCGPDFContextTitle: title
        ]

        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        // Yatay A4 boyutu
        let pageWidth = 842.0
        let pageHeight = 595.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        let data = renderer.pdfData { context in
            context.beginPage()
            var yOffset: CGFloat = 30
            let leftMargin: CGFloat = 50 // Sol tarafa eklenen boşluk

            // Başlık ve alt başlık
            let titleFont = UIFont.boldSystemFont(ofSize: 18)
            let subtitleFont = UIFont.systemFont(ofSize: 15)
            let titleAttributes: [NSAttributedString.Key: Any] = [.font: titleFont]
            let subtitleAttributes: [NSAttributedString.Key: Any] = [.font: subtitleFont]

            title.draw(at: CGPoint(x: pageWidth / 2.5, y: yOffset), withAttributes: titleAttributes)
            yOffset += titleFont.lineHeight

            subtitle.draw(at: CGPoint(x: pageWidth / 2.5, y: yOffset), withAttributes: subtitleAttributes)
            yOffset += subtitleFont.lineHeight + 30

            // Tablo başlıkları
            let headers = ["Tarih", "Açıklama", "Borç", "Alacak", "Bakiye"]
            let columnWidths = [140.0, 320.0, 110.0, 110.0, 110.0]
            for (index, header) in headers.enumerated() {
                let headerRect = CGRect(x: CGFloat(sum(columnWidths, upTo: index)) + leftMargin, y: yOffset, width: CGFloat(columnWidths[index]), height: 30)
                header.draw(in: headerRect, withAttributes: titleAttributes)
            }
            yOffset += 30

            // Tablo maddeleri ve toplamlar
            for (index, entry) in entries.enumerated() {
                let isDoubleDigit = index % 2 == 0 // Çift haneli satırlar için kontrol
                let backgroundColor = isDoubleDigit ? UIColor.primaryVeryLightGray : UIColor.white
                let rowRect = CGRect(x: leftMargin, y: yOffset, width: pageWidth - leftMargin, height: 22)

                context.cgContext.saveGState() // Grafik durumunu kaydet
                context.cgContext.setFillColor(backgroundColor.cgColor)
                context.cgContext.fill(rowRect)
                context.cgContext.restoreGState() // Grafik durumunu geri yükle

                let row = [
                    entry.date.dateFormatToAppDisplayType() ?? "",
                    entry.description,
                    entry.debit.decimalString() == "0" ? "" : entry.debit.decimalTwoString(),
                    entry.credit.decimalString() == "0" ? "" : entry.credit.decimalTwoString(),
                    entry.balance.decimalString() == "0" ? "" : entry.balance.decimalTwoString()
                ]

                for (index, text) in row.enumerated() {
                    let cellRect = CGRect(x: CGFloat(sum(columnWidths, upTo: index)) + leftMargin, y: yOffset, width: CGFloat(columnWidths[index]), height: 22)
                    text.draw(in: cellRect, withAttributes: subtitleAttributes)
                }
                yOffset += 22

                // Yeni sayfa başlatma kontrolü
                if yOffset >= pageHeight - 60 {
                    context.beginPage()
                    yOffset = 30
                }
            }

            // Sütun toplamları
            let totalsRow = ["", "Genel Toplam", totalDebit.decimalString(), totalCredit.decimalString(), totalBalance.decimalString()]
            let totalAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 15)]
            for (index, text) in totalsRow.enumerated() {
                let cellRect = CGRect(x: CGFloat(sum(columnWidths, upTo: index)) + leftMargin, y: yOffset + 10, width: CGFloat(columnWidths[index]), height: 40)
                text.draw(in: cellRect, withAttributes: totalAttributes)
            }
        }

        return data
    }

    private func sum(_ array: [Double], upTo index: Int) -> Double {
        return array[..<index].reduce(0, +)
    }
}
