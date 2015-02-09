//
//  TwitterClient.h
//  Twitter
//
//  Created by Matt Ho on 2/7/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "Tweet.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)composeTweet:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion;

@end
