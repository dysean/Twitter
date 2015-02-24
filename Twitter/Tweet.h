//
//  Tweet.h
//  Twitter
//
//  Created by Sean Dy on 2/22/15.
//  Copyright (c) 2015 Sean Dy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@class Tweet;
@protocol TweetDelegate <NSObject>

@end
@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
//@property (nonatomic) NSInteger *retweetCount;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *createdAtWithFormat;
@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic, strong) NSArray *mentions;
@property (nonatomic) bool retweeted;
@property (nonatomic) bool favorited;



- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void) retweet;
- (void) favorite;


+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
