//
//  Tweet.m
//  Twitter
//
//  Created by Sean Dy on 2/22/15.
//  Copyright (c) 2015 Sean Dy. All rights reserved.
//

#import "Tweet.h"
#import "TwitterClient.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self){
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        self.tweetId = dictionary[@"id"];
        NSString *createdAtString = dictionary[@"created_at"];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.mentions = dictionary[@"entities"][@"user_mentions"];
        
//        self.retweetCount = dictionary[@"retweetCount"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
        NSDate *currentTime = [[NSDate alloc] init];
        NSTimeInterval secSinceTweet = [currentTime timeIntervalSinceDate:self.createdAt];
        if (secSinceTweet <= 60 ) {
            self.createdAtWithFormat = @"1m ago";
        } else if (secSinceTweet < 60 * 60) {
            self.createdAtWithFormat = [NSString stringWithFormat:@"%0.0fm ago",floor(secSinceTweet/60)];
        } else if (secSinceTweet <= 60 * 60) {
            self.createdAtWithFormat = [NSString stringWithFormat:@"%0.0fh ago",floor(secSinceTweet/(60*60))];
        } else if (secSinceTweet <= 60 * 60 * 24) {
            self.createdAtWithFormat = [NSString stringWithFormat:@"%0.0fd ago",floor(secSinceTweet/(60*60 *24))];
        } else if (secSinceTweet <= 60 * 60 * 24 * 7) {
            self.createdAtWithFormat = [NSString stringWithFormat:@"%0.0fw ago",floor(secSinceTweet/(60*60 *24 * 7))];
        } else if (secSinceTweet <= 60 * 60 * 24 * 7 * 4) {
            self.createdAtWithFormat = [NSString stringWithFormat:@"%0.0fm ago",floor(secSinceTweet/(60*60 *24 * 7 * 4))];
        } else if (secSinceTweet <= 60 * 60 * 24 * 7 * 52) {
            self.createdAtWithFormat = [NSString stringWithFormat:@"%0.0fy ago",floor(secSinceTweet/(60*60 *24 * 7 * 4 * 52))];
        } else {
            self.createdAtWithFormat = @"0m ago";
        }
        
    }
    return self;
}

- (void) retweet {
    if (self.retweeted) {
        NSLog(@"already retweeted");
    } else {
        [[TwitterClient sharedInstance] retweetWithTweetId:self.tweetId completion:^(NSArray *tweets, NSError *error) {
            if (!error) {
                self.retweeted = TRUE;
            } else {
                NSLog(@"error retweeting");
            }
        }];
        
    }
}

- (void) favorite {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.tweetId forKey:@"id"];
    if (self.favorited) {
        NSLog(@"already favorite, delete");
        NSString *favEndpoint = @"destroy";
        [[TwitterClient sharedInstance] toggleFavoriteWithParams:params endpoint:favEndpoint completion:^(NSArray *tweets, NSError *error) {
            if (!error) {
                NSLog(@"deletion success");
                self.favorited = FALSE;
            } else {
                NSLog(@"deletion failed");
            }
            
        }];
    } else {
        NSLog(@"not favorite, create");
        NSString *favEndpoint = @"create";
        [[TwitterClient sharedInstance] toggleFavoriteWithParams:params endpoint:favEndpoint completion:^(NSArray *tweets, NSError *error) {
            if (!error) {
                NSLog(@"creation success");
                self.favorited = TRUE;
            } else {
                NSLog(@"creation failed");
            }
        }];
    }
}


+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets  = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
        
        
    }
    return tweets;
}

@end
