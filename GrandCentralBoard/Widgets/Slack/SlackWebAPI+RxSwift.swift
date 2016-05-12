//
//  SlackWebAPI+RxSwift.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 11.05.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import SlackKit
import RxSwift
import GrandCentralBoardCore


struct ErrorWithMessage: ErrorType, HavingMessage {
    let message: String
}

private func completionsForObserver<T>(observer: AnyObserver<T>) -> (success: (T?) -> Void, failure: SlackWebAPI.FailureClosure) {

    let success: (T?) -> Void = { object -> Void in
        if let object = object {
            observer.onNext(object)
        } else {
            observer.onError(ErrorWithMessage(message: "Missing data from Slack for type \(T.self)"))
        }
        observer.onCompleted()
    }

    let failure: SlackWebAPI.FailureClosure = { error in
        observer.onError(error)
        observer.onCompleted()
    }

    return (success: success, failure: failure)
}

extension SlackWebAPI {
    func channelInfo(id: String) -> Observable<Channel> {
        return Observable.create { (observer: AnyObserver<Channel>) -> Disposable in
            let completions = completionsForObserver(observer)
            self.channelInfo(id, success: completions.success, failure: completions.failure)
            return NopDisposable.instance
        }
    }

    func userInfo(id: String) -> Observable<User> {
        return Observable.create({ (observer: AnyObserver<User>) -> Disposable in
            let completions = completionsForObserver(observer)
            self.userInfo(id, success: completions.success, failure: completions.failure)
            return NopDisposable.instance
        })
    }
}
