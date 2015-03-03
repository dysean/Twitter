//
//  TwitterClient.h
//  Twitter
//
//  Created by Sean Dy on 2/22/15.
//  Copyright (c) 2015 Sean Dy. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openUrl:(NSURL *)url;
- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)mentionsTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)userTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)retweetWithTweetId:(NSString *)tweetId completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)toggleFavoriteWithParams:(NSDictionary *)params endpoint:(NSString *)endpoint completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)composeTweetWithParameters:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;

@end
