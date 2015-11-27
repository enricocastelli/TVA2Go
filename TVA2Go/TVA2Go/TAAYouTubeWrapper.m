//
//  TAAYouTubeWrapper.m
//  TAAYouTubeWrapper
//
//  Created by Daniel Salber on 24/11/15.
//  Copyright © 2015 The App Academy. All rights reserved.
//
//  Version: 1.0, 27-Nov-2015
//

#import "TAAYouTubeWrapper.h"
#import "GTLYouTube.h"

@interface TAAYouTubeWrapper ()

@property GTLServiceYouTube *youTubeService;

@end

@implementation TAAYouTubeWrapper

#pragma mark - Public API

+ (void)videosForUser:(NSString *)userName onCompletion:(void (^)(BOOL succeeded, NSArray *videos, NSError *error))completionBlock
{
    return [[TAAYouTubeWrapper sharedInstance] videosForUserName:userName onCompletion:completionBlock];
}

+ (void)videosForPlaylist:(NSString *)playlistName forUser:(NSString *)userName onCompletion:(void (^)(BOOL succeeded, NSArray *videos, NSError *error))completionBlock
{
    return [[TAAYouTubeWrapper sharedInstance] videosForPlaylistName:playlistName forUserName:userName onCompletion:completionBlock];
}

+ (void)playlistsForUser:(NSString *)userName onCompletion:(void (^)(BOOL succeeded, NSArray *playlists, NSError *error))completionBlock
{
    return [[TAAYouTubeWrapper sharedInstance] playlistsForUserName:userName onCompletion:completionBlock];
}


#pragma mark - Init

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.youTubeService = [GTLServiceYouTube new];
        self.youTubeService.APIKey = kYouTubeAPIKey;
        NSAssert(self.youTubeService.APIKey.length > 0, @"You need to provide a valid API key.");
    }
    return self;
}


#pragma mark - Internal API

- (void)videosForUserName:(NSString *)userName onCompletion:(void (^)(BOOL succeeded, NSArray *videos, NSError *error))completionBlock
{
    NSParameterAssert(userName);
    
    [self channelForUserName:userName onCompletion:^(BOOL succeeded, GTLYouTubeChannel *channel, NSError *error) {
        if (succeeded) {
            NSAssert(channel, @"no channel");
            NSAssert1(error == nil, @"error: %@", error.localizedDescription);
            NSString *uploadsID = channel.contentDetails.relatedPlaylists.uploads;
            if (uploadsID.length > 0) {
                [self videosForPlaylistIdentifier:uploadsID onCompletion:^(BOOL succeeded, NSArray *videos, NSError *error) {
                    if (succeeded) {
                        NSAssert1(error == nil, @"error: %@", error.localizedDescription);
                    }
                    if (completionBlock) {
                        completionBlock(succeeded, videos, error);
                    }
                }];
            }
        } else if (completionBlock) {
            completionBlock(succeeded, nil, error);
        }
    }];
}

// username -> channel -> playlists -> playlist matching playlist name -> videos
- (void)videosForPlaylistName:(NSString *)playlistName forUserName:(NSString *)userName onCompletion:(void (^)(BOOL succeeded, NSArray *videos, NSError *error))completionBlock
{
    NSParameterAssert(playlistName);
    NSParameterAssert(userName);

    [self channelForUserName:userName onCompletion:^(BOOL succeeded, GTLYouTubeChannel *channel, NSError *error) {
        if (succeeded) {
            NSAssert(channel, @"no channel");
            NSAssert1(error == nil, @"error: %@", error.localizedDescription);
            [self playlistsForChannel:channel onCompletion:^(BOOL succeeded, NSArray *playlists, NSError *error) {
                if (succeeded) {
                    NSAssert1(error == nil, @"error: %@", error.localizedDescription);
                    NSArray *filteredPlaylists = [playlists filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                        NSAssert([evaluatedObject isKindOfClass:[GTLYouTubePlaylist class]], @"not a playlist");
                        GTLYouTubePlaylist *playlist = evaluatedObject;
                        GTLYouTubePlaylistSnippet *snippet = playlist.snippet;
                        NSAssert1(snippet, @"no snippet for playlist %@", playlist);
                        return [snippet.title isEqualToString:playlistName];
                    }]];
                    GTLYouTubePlaylist *foundPlaylist = [filteredPlaylists firstObject];
                    if (foundPlaylist) {
                        [self videosForPlaylist:foundPlaylist onCompletion:completionBlock];
                    } else if (completionBlock) {
                        completionBlock(succeeded, nil, error);
                    }
                } else if (completionBlock) {
                    completionBlock(succeeded, nil, error);
                }
            }];
        } else if (completionBlock) {
            completionBlock(succeeded, nil, error);
        }
    }];
}

- (void)playlistsForUserName:(NSString *)userName onCompletion:(void (^)(BOOL succeeded, NSArray *playlists, NSError *error))completionBlock
{
    NSParameterAssert(userName);
    
    [self channelForUserName:userName onCompletion:^(BOOL succeeded, GTLYouTubeChannel *channel, NSError *error) {
        if (succeeded) {
            NSAssert(channel, @"no channel");
            NSAssert1(error == nil, @"error: %@", error.localizedDescription);
            [self playlistsForChannel:channel onCompletion:^(BOOL succeeded, NSArray *playlists, NSError *error) {
                if (succeeded) {
                    NSAssert1(error == nil, @"error: %@", error.localizedDescription);
                }
                if (completionBlock) {
                    completionBlock(succeeded, playlists, error);
                }
            }];
        } else if (completionBlock) {
            completionBlock(succeeded, nil, error);
        }
    }];
}


#pragma mark - YouTube Queries

// playlist -> playlist items -> videos
- (void)videosForPlaylist:(GTLYouTubePlaylist *)playlist onCompletion:(void (^)(BOOL succeeded, NSArray *videos, NSError *error))completionBlock
{
    NSParameterAssert(playlist);
    
    [self videosForPlaylistIdentifier:playlist.identifier onCompletion:completionBlock];
}

// playlist ID -> playlist items -> videos
- (void)videosForPlaylistIdentifier:(NSString *)playlistIdentifier onCompletion:(void (^)(BOOL succeeded, NSArray *videos, NSError *error))completionBlock
{
    NSParameterAssert(playlistIdentifier);
    
    static NSString *playlistItemParts = @"id,snippet,contentDetails,status";
    GTLQueryYouTube *playlistItemsQuery = [GTLQueryYouTube queryForPlaylistItemsListWithPart:playlistItemParts];
    playlistItemsQuery.playlistId = playlistIdentifier;
    
    [self.youTubeService executeQuery:playlistItemsQuery completionHandler:^(GTLServiceTicket *ticket, GTLYouTubePlaylistItemListResponse *object, NSError *error) {
        NSArray *playlistItems = nil;
        if (!error) {
            playlistItems = object.items;
            [self videosForPlaylistItems:playlistItems onCompletion:^(BOOL succeeded, NSArray *videos, NSError *error) {
                if (succeeded) {
                    NSAssert1(error == nil, @"error: %@", error.localizedDescription);
                    if (completionBlock) {
                        completionBlock(succeeded, videos, error);
                    }
                }
            }];
        } else {
            if (completionBlock) {
                completionBlock(error == nil, playlistItems, error);
            }
        }
    }];
}

// playlist items -> videos
- (void)videosForPlaylistItems:(NSArray *)playlistItems onCompletion:(void (^)(BOOL succeeded, NSArray *videos, NSError *error))completionBlock
{
    NSParameterAssert(playlistItems);

    static NSString *videoParts = @"id,snippet,contentDetails,status";
    NSArray *videosIDs = [NSArray new];
    
    // extract video IDs from playlistItems
    for (GTLYouTubePlaylistItem *playlistItem in playlistItems) {
        GTLYouTubePlaylistItemContentDetails *contentDetails = playlistItem.contentDetails;
        NSString *videoID = contentDetails.videoId;
        NSAssert(videoID.length > 0, @"empty ID");
        videosIDs = [videosIDs arrayByAddingObject:videoID];
    }
    
    GTLQueryYouTube *videosQuery = [GTLQueryYouTube queryForVideosListWithPart:videoParts];
    NSAssert(videosIDs.count > 0, @"no IDs found");
    videosQuery.identifier = (videosIDs.count > 1 ? [videosIDs componentsJoinedByString:@","] : [videosIDs firstObject]);
    
    [self.youTubeService executeQuery:videosQuery completionHandler:^(GTLServiceTicket *ticket, GTLYouTubeVideoListResponse *object, NSError *error) {
        NSArray *videos = nil;
        if (!error) {
            videos = object.items;
        }
        if (completionBlock) {
            completionBlock(error == nil, videos, error);
        }
    }];
}

- (void)channelForUserName:(NSString *)userName onCompletion:(void (^)(BOOL succeeded, GTLYouTubeChannel *channel, NSError *error))completionBlock
{
    NSParameterAssert(userName);
    
    static NSString *channelParts = @"id,snippet,brandingSettings,contentDetails,invideoPromotion,statistics,status,topicDetails";
    
    GTLQueryYouTube *channelQuery = [GTLQueryYouTube queryForChannelsListWithPart:channelParts];
    channelQuery.forUsername = userName;
    
    [self.youTubeService executeQuery:channelQuery completionHandler:^(GTLServiceTicket *ticket, GTLYouTubeChannelListResponse *object, NSError *error) {
        GTLYouTubeChannel *channel = nil;
        if (!error) {
            channel = [object.items firstObject];
        }
        if (completionBlock) {
            completionBlock(error == nil, channel, error);
        }
    }];
}

- (void)playlistsForChannel:(GTLYouTubeChannel *)channel onCompletion:(void (^)(BOOL succeeded, NSArray *playlists, NSError *error))completionBlock
{
    NSParameterAssert(channel);
    
    static NSString *playlistParts = @"id,snippet,contentDetails,status";
    GTLQueryYouTube *playlistsQuery = [GTLQueryYouTube queryForPlaylistsListWithPart:playlistParts];
    playlistsQuery.channelId = channel.identifier;
    
    [self.youTubeService executeQuery:playlistsQuery completionHandler:^(GTLServiceTicket *ticket, GTLYouTubePlaylistListResponse *object, NSError *error) {
        NSArray *playlists = nil;
        if (!error) {
            playlists = object.items;
        }
        if (completionBlock) {
            completionBlock(error == nil, playlists, error);
        }
    }];
}

@end
