//
//  HistoryModels.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 26.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum History {
    
    enum Model {
        struct Request {
            enum RequestType {
                case loadHistory
                case saveNewHistory(history: HistoryViewModel)
            }
        }
        struct Response {
            enum ResponseType {
                case prepareHistory(response: [String])
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayHistory(HistoryViewModel)
            }
        }
    }
}

struct HistoryViewModel {
    var terms: [String]
}
