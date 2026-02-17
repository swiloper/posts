//
//  MediaAttachment.swift
//  Persistence
//
//  Created by Ihor Myronishyn on 17.02.2026.
//

import Entities
import SwiftData
import Foundation

@Model
public final class MediaAttachment {
    
    // MARK: - Properties
    
    @Attribute(.unique)
    public var id: String
    public var type: String
    public var url: String?
    public var preview: String?
    
    @Relationship(deleteRule: .cascade)
    public var meta: Meta?
    
    @Relationship(inverse: \Post.mediaAttachments)
    public var post: Post?
    
    public var order: Int
    
    // MARK: - Init
    
    public init(attachment: Entities.MediaAttachment, order: Int) {
        self.id = attachment.id
        self.type = attachment.type.rawValue
        self.url = attachment.url
        self.preview = attachment.preview
        self.meta = attachment.meta.map({ Meta(meta: $0) })
        self.order = order
    }
}

// MARK: - Meta

@Model
public final class Meta {
    
    // MARK: - Properties
    
    @Relationship(deleteRule: .cascade)
    public var small: Info?
    
    @Relationship(inverse: \MediaAttachment.meta)
    public var mediaAttachment: MediaAttachment?
    
    // MARK: - Init
    
    public init(meta: Entities.MediaAttachment.Meta) {
        self.small = meta.small.map({ Info(info: $0) })
    }
}

// MARK: - Info

@Model
public final class Info {
    
    // MARK: - Properties
    
    public var width: CGFloat?
    public var height: CGFloat?
    public var aspect: CGFloat?
    public var duration: CGFloat?
    
    @Relationship(inverse: \Meta.small)
    public var meta: Meta?
    
    // MARK: - Init
    
    public init(info: Entities.MediaAttachment.Info) {
        self.width = info.width
        self.height = info.height
        self.aspect = info.aspect
        self.duration = info.duration
    }
}

// MARK: - Domain

public extension MediaAttachment {
    func domain() -> Entities.MediaAttachment {
        Entities.MediaAttachment(
            id: id,
            type: Entities.MediaAttachment.MediaType(rawValue: type) ?? .unknown,
            url: url,
            preview: preview,
            meta: meta?.domain()
        )
    }
}

public extension Meta {
    func domain() -> Entities.MediaAttachment.Meta {
        Entities.MediaAttachment.Meta(
            small: small?.domain()
        )
    }
}

public extension Info {
    func domain() -> Entities.MediaAttachment.Info {
        Entities.MediaAttachment.Info(
            width: width,
            height: height,
            aspect: aspect,
            duration: duration
        )
    }
}
