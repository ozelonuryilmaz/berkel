//
//  InvoicePDFCreator.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.05.2024.
//

import UIKit
import PDFKit

class InvoicePDFCreator {
    var items: [InvoiceItem]
    var totalAmount: Double {
        return items.reduce(0) { $0 + $1.price }
    }

    struct InvoiceItem {
        let dateString: String
        let productName: String
        let invoiceNumber: String
        let price: Double
    }

    init(items: [InvoiceItem]) {
        self.items = items
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

        let pageWidth = 595.2
        let pageHeight = 841.8
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        let data = renderer.pdfData { context in
            context.beginPage()
            var yOffset: CGFloat = 30

            // Başlıkları çizme
            let titleFont = UIFont.boldSystemFont(ofSize: 18)
            let subtitleFont = UIFont.systemFont(ofSize: 15)
            let titleAttributes: [NSAttributedString.Key: Any] = [.font: titleFont]
            let subtitleAttributes: [NSAttributedString.Key: Any] = [.font: subtitleFont]

            title.draw(at: CGPoint(x: pageWidth / 3, y: yOffset), withAttributes: titleAttributes)
            yOffset += titleFont.lineHeight

            subtitle.draw(at: CGPoint(x: pageWidth / 3, y: yOffset), withAttributes: subtitleAttributes)
            yOffset += subtitleFont.lineHeight + 30

            // Tablo başlıklarını çizme
            let headers = ["Tarih", "Açıklama", "Fatura No", "Tutar"]
            let columnWidth = pageWidth / CGFloat(headers.count)
            for (index, header) in headers.enumerated() {
                let headerRect = CGRect(x: CGFloat(index) * columnWidth, y: yOffset, width: columnWidth, height: 30)
                header.draw(in: headerRect, withAttributes: titleAttributes)
            }
            yOffset += 30

            // Tablo maddelerini çizme
            for (index, item) in items.enumerated() {
                if index % 20 == 0 && index != 0 { // Her 20 maddede bir yeni sayfa başlat
                    context.beginPage()
                    yOffset = 30
                }

                let isSingleDigit = index % 2 == 0 // çift haneli satırlar gri olur
                let backgroundColor = isSingleDigit ? UIColor.primaryLightGray : UIColor.white
                let textRect = CGRect(x: 0, y: yOffset, width: pageWidth, height: 30)

                context.cgContext.saveGState() // Grafik durumunu kaydet
                context.cgContext.setFillColor(backgroundColor.cgColor)
                context.cgContext.fill(textRect)
                context.cgContext.restoreGState() // Grafik durumunu geri yükle

                let row = [
                    item.dateString,
                    item.productName,
                    item.invoiceNumber,
                    "\(item.price)"
                ]

                for (columnIndex, text) in row.enumerated() {
                    let cellRect = CGRect(x: CGFloat(columnIndex) * columnWidth, y: yOffset, width: columnWidth, height: 30)
                    text.draw(in: cellRect.insetBy(dx: 5, dy: 5), withAttributes: subtitleAttributes)
                }

                yOffset += 30
            }

            // Son sayfada toplam tutarı çizme
            if yOffset >= pageHeight - 40 {
                context.beginPage()
                yOffset = 30
            }

            //let totalTitle = "Toplam Tutar"
            let totalAmountString = "Toplam Tahsilat: \(totalAmount.decimalString())TL\nBekleyen Tahsilat: \(totalAmount.decimalString())TL\nToplam Tutar: \(totalAmount.decimalString())TL"
            let totalAmountSize = totalAmountString.size(withAttributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
            
            let totalAmountRect = CGRect(x: pageWidth - totalAmountSize.width - 100, y: yOffset + 40, width: totalAmountSize.width, height: totalAmountSize.height)
            totalAmountString.draw(in: totalAmountRect, withAttributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        }

        return data
    }
}
