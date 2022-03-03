//
//  ImageCommentsPresenter.swift
//  EDNLearn
//
//  Created by Pankaj Mangotra on 02/03/22.
//

import Foundation

public struct ImageCommentsViewModel {
    public let comments: [ImageCommentViewModel]
}

public struct ImageCommentViewModel: Equatable {
    public let message: String
    public let date: String
    public let username: String

    public init(message: String, date: String, username: String) {
        self.message = message
        self.date = date
        self.username = username
    }
}

public final class ImageCommentsPresenter {
    public static var title: String {
        return NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE",
                                 tableName: "ImageComments",
                                 bundle: Bundle(for: Self.self),
                                 comment: "Title for the Image comments view")
    }

    @available(macOS 10.15, *)
    public static func map(
        _ comments: [ImageComment],
        currentDate: Date = Date(),
        currentCalendar: Calendar = .current,
        currentLocale: Locale = .current
    ) -> ImageCommentsViewModel {
        let formatter = RelativeDateTimeFormatter()
        formatter.calendar = currentCalendar
        formatter.locale = currentLocale

        return ImageCommentsViewModel(comments: comments.map { comment in
            ImageCommentViewModel(
                message: comment.message,
                date: formatter.localizedString(for: comment.createAt, relativeTo: currentDate),
                username: comment.username
            )
        })
    }
}
