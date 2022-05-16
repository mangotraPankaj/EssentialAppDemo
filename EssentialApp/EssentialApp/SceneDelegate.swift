//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Pankaj Mangotra on 27/12/21.
//

import Combine
import CoreData
import EDNLearnMac
import EssentialFeediOS
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var httpClient: HTTPClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))

    private lazy var store: FeedStore & FeedImageDataStore = try! CoreDataFeedStore(storeURL: NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("feed-store.sqlite"))

    private lazy var localFeedLoader: LocalFeedLoader = .init(store: store, currentDate: Date.init)

    private lazy var navigationController = UINavigationController(
        rootViewController: FeedUIComposer.feedComposedWith(
            feedLoader: makeRemoteFeedLoaderWithLocalFallback,
            imageLoader: makeLocalImageLoaderWithRemoteFallback,
            selection: showComments
        ))

    private lazy var baseURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed")!

    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        configureWindow()
    }

    func configureWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneWillResignActive(_: UIScene) {
        localFeedLoader.validateCache { _ in }
    }

    private func showComments(for image: FeedImage) {
        let url = baseURL.appendingPathComponent("/v1/image/\(image.id)/comments")
        let comments = CommentsUIComposer.commentsComposedWith(commentsLoader: makeRemoteCommentsLoader(url: url))
        navigationController.pushViewController(comments, animated: true)
    }

    private func makeRemoteCommentsLoader(url: URL) -> () -> AnyPublisher<[ImageComment], Error> {
        return { [httpClient] in
            httpClient
                .getPublisher(url: url)
                .tryMap(ImageCommentsMapper.map)
                .eraseToAnyPublisher()
        }
    }

    private func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<Paginated<FeedImage>, Error> {
        let remoteURL = baseURL.appendingPathComponent("/v1/feed")

        return httpClient
            .getPublisher(url: remoteURL)
            .tryMap(FeedItemMapper.map)
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
            .map {
                Paginated(items: $0)
            }.eraseToAnyPublisher()

        /* Above way is the way of Composing the use cases with infrastructure in a functional way. Dont inject dependencies but compose them with map, tryMap,flatMap etc.

                  -[side effect]-
                  -pure function -
                  -[side effect]-

                 /// the below code can be used if we dont want to have combine.
                 /// Create the remote FeedLoader with the mapper and compose it
         //        let remoteFeedLoader = RemoteLoader(url: remoteURL, client: httpClient, mapper: FeedItemMapper.map)
         //
         //        return remoteFeedLoader
         //            .loadPublisher()
         //            .caching(to: localFeedLoader)
         //            .fallback(to: localFeedLoader.loadPublisher)
                  */
    }

    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoader.Publisher {
        let remoteImageLoader = RemoteFeedImageDataLoader(client: httpClient)
        let localImageLoader = LocalFeedImageDataLoader(store: store)

        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: {
                remoteImageLoader
                    .loadImageDataPublisher(from: url)
                    .caching(to: localImageLoader, using: url)
            })
    }
}

/*

  /// The below RemoteFeedLoader is not required once we have used tryMap in composition root as done in makeRemoteFeedLoaderWithLocalFallback function.

 extension RemoteLoader: FeedLoader where Resource == [FeedImage] {}

 public typealias RemoteImageCommentsLoader = RemoteLoader<[ImageComment]>

 // Commenting the below code as it is not needed now. Will need once UI is ready

 // public extension RemoteImageCommentsLoader {
 //    convenience init(url: URL, client: HTTPClient) {
 //        self.init(url: url, client: client, mapper: ImageCommentsMapper.map)
 //    }
 // }

 public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

 public extension RemoteFeedLoader {
     convenience init(url: URL, client: HTTPClient) {
         self.init(url: url, client: client, mapper: FeedItemMapper.map)
     }
 }*/
