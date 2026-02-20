//
//  MediaAttachment.swift
//  Entities
//
//  Created by Ihor Myronishyn on 13.02.2026.
//

import Foundation

public struct MediaAttachment: Codable, Identifiable, Hashable, Sendable {
    
    // MARK: - Properties
    
    public let id: String
    public let type: MediaType
    public let url: String?
    public let preview: String?
    public let meta: Meta?
    
    // MARK: - Init
    
    public init(id: String, type: MediaType, url: String?, preview: String?, meta: Meta?) {
        self.id = id
        self.type = type
        self.url = url
        self.preview = preview
        self.meta = meta
    }
    
    // MARK: - Keys
    
    enum CodingKeys: String, CodingKey {
        case id, type, url, meta
        case preview = "preview_url"
    }
}

// MARK: - Type

public extension MediaAttachment {
    enum MediaType: String, Codable, Hashable, Sendable {
        case image, video, gifv, audio, unknown
    }
}

// MARK: - Meta

public extension MediaAttachment {
    struct Meta: Codable, Hashable, Sendable {
        
        // MARK: - Properties
        
        public let small: Info?
        
        // MARK: - Init
        
        public init(small: Info?) {
            self.small = small
        }
    }
}

// MARK: - Info

public extension MediaAttachment {
    struct Info: Codable, Hashable, Sendable {
        
        // MARK: - Properties
        
        public let width: CGFloat?
        public let height: CGFloat?
        public let aspect: CGFloat?

        public let duration: CGFloat?
        
        public var ratio: CGFloat {
            if let aspect {
                return aspect
            } else if let width, let height {
                return width / height
            }
            
            return 1
        }
        
        // MARK: - Init
        
        public init(width: CGFloat?, height: CGFloat?, aspect: CGFloat?, duration: CGFloat? = nil) {
            self.width = width
            self.height = height
            self.aspect = aspect
            self.duration = duration
        }
    }
}

// MARK: - Preview

public extension MediaAttachment {
    static let preview = MediaAttachment(
        id: "116100948164867427",
        type: .image,
        url: "https://files.mastodon.social/cache/media_attachments/files/116/100/948/164/867/427/original/457b33d35b6254a3.jpg",
        preview: "https://files.mastodon.social/cache/media_attachments/files/116/100/948/164/867/427/small/457b33d35b6254a3.jpg",
        meta: Meta(
            small: Info(
                width: 607,
                height: 380,
                aspect: 1.6
            )
        )
    )
}
