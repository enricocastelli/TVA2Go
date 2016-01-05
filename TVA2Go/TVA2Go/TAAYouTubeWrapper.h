//
//  TAAYouTubeWrapper.h
//  TAAYouTubeWrapper
//
//  Created by Daniel Salber on 24/11/15.
//  Copyright © 2015 The App Academy. All rights reserved.
//
//
//  How to use:
//  - add Google-API-Client/YouTube to your Podfile
//  - copy TAAYouTubeWrapper.h/m into your project (not into the Pods)
//

#import <Foundation/Foundation.h>

@interface TAAYouTubeWrapper : NSObject

// gets all the uploaded videos for the given user name as an array of GTLYouTubeVideo objects

+ (void)videosForUser:(NSString *)userName onCompletion:(void (^)(BOOL succeeded, NSArray *videos, NSError *error))completionBlock;

// gets all the videos in the given playlist for the given user name as an array of GTLYouTubeVideo objects

+ (void)videosForPlaylist:(NSString *)playlistName forUser:(NSString *)userName onCompletion:(void (^)(BOOL succeeded, NSArray *videos, NSError *error))completionBlock;

// gets all the playlists for the given user name as an array of GTLYouTubePlaylist objects

+ (void)playlistsForUser:(NSString *)userName onCompletion:(void (^)(BOOL succeeded, NSArray *playlists, NSError *error))completionBlock;

@end
