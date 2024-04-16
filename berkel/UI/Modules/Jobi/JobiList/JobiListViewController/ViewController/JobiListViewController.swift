//
//  JobiListViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit
import Combine

import CoreGraphics
import WebKit

final class JobiListViewController: JobiBaseViewController {

    override var navigationTitle: String? {
        return "Jobi"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IJobiListViewModel

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IJobiListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "JobiListViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()
    }

    override func registerEvents() {

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
        // Kullanımı:
        let pdfCreator = PDFCreator(pdfFilePath: NSTemporaryDirectory() + "ornek.pdf")
        pdfCreator.createPDF()

        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14)]
        pdfCreator.addContentToColumn(content: "Sütun 1, Madde 1", attributes: attributes, columnIndex: 0)
        pdfCreator.addContentToColumn(content: "Sütun 1, Madde 2", attributes: attributes, columnIndex: 0)
        pdfCreator.addContentToColumn(content: "Sütun 2, Madde 1", attributes: attributes, columnIndex: 1)
        pdfCreator.addContentToColumn(content: "Sütun 2, Madde 2", attributes: attributes, columnIndex: 1)

        let pdfPath = pdfCreator.finalizePDF()
        print("PDF dosyası burada oluşturuldu: \(pdfPath)")

        sharePDF(pdfFilePath: pdfPath)*/
        
        
        // Kullanımı:
        /*let htmlString = "<html><body><p>Bu bir HTML örneğidir.</p></body></html>"
        let pdfCreator = HTMLToPDFConverter(html: htmlString, pdfFilePath: "pdf_dosyasi.pdf")
        pdfCreator.convertToPDF {
            print("PDF başarıyla oluşturuldu ve kaydedildi.")
        }*/
        

    }

    private func observeReactiveDatas() {
        observeViewState()
        listenErrorState()
    }

    private func observeViewState() {
        viewModel.viewState.sink(receiveValue: { [weak self] states in
            guard let self = self, let states = states else { return }

            switch states {
            case .showNativeProgress(let isProgress):
                self.playNativeLoading(isLoading: isProgress)

            }

        }).store(in: &cancelBag)
    }

    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(viewController: self)
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }

    // MARK: Define Components
}

// MARK: Props
private extension JobiListViewController {

    
    func sharePDF(pdfFilePath: String) {
        if let pdfData = NSData(contentsOfFile: pdfFilePath) {
            let activityViewController = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
            
            // iPad için popover sunumu
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = self.view
                // Popover'ın gösterileceği konumu ayarlayın
                popoverController.sourceRect = self.view.bounds
            }
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}



class PDFCreator {
    var currentHeight: CGFloat = 0
    let pageWidth: CGFloat = 595
    let pageHeight: CGFloat = 842
    let columnCount: Int = 2 // Sütun sayısı
    var pdfFilePath: String
    
    init(pdfFilePath: String) {
        self.pdfFilePath = pdfFilePath
    }
    
    func createPDF() {
        UIGraphicsBeginPDFContextToFile(pdfFilePath, CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), nil)
        addNewPage()
    }
    
    func addContentToColumn(content: String, attributes: [NSAttributedString.Key: Any], columnIndex: Int) {
        let columnWidth = pageWidth / CGFloat(columnCount)
        let xOffset = columnWidth * CGFloat(columnIndex)
        
        let stringSize = content.boundingRect(with: CGSize(width: columnWidth, height: CGFloat.infinity),
                                              options: .usesLineFragmentOrigin,
                                              attributes: attributes,
                                              context: nil).size
        
        if currentHeight + stringSize.height > pageHeight {
            addNewPage()
        }
        
        content.draw(in: CGRect(x: xOffset, y: currentHeight, width: columnWidth, height: stringSize.height), withAttributes: attributes)
        currentHeight += stringSize.height
    }
    
    private func addNewPage() {
        UIGraphicsBeginPDFPage()
        currentHeight = 0
    }
    
    func finalizePDF() -> String {
        UIGraphicsEndPDFContext()
        return pdfFilePath
    }
}


class HTMLToPDFConverter {
    private var webView: WKWebView!
    private var pdfFilePath: String
    
    init(html: String, pdfFilePath: String) {
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 595, height: 842))
        self.pdfFilePath = pdfFilePath
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    func convertToPDF(completion: @escaping () -> Void) {
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(webView.viewPrintFormatter(), startingAtPageAt: 0)
        
        let pageFrame = CGRect(x: 0, y: 0, width: webView.frame.width, height: webView.frame.height)
        render.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
        render.setValue(NSValue(cgRect: pageFrame.insetBy(dx: 10, dy: 10)), forKey: "printableRect")
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pageFrame, nil)
        
        for i in 0..<render.numberOfPages {
            UIGraphicsBeginPDFPage()
            render.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
        
        if pdfData.write(toFile: pdfFilePath, atomically: true) {
            completion()
        } else {
            print("PDF dosyası oluşturulamadı.")
        }
    }
}

