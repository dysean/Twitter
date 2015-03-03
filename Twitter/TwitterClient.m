//
//  TwitterClient.m
//  Twitter
//
//  Created by Sean Dy on 2/22/15.
//  Copyright (c) 2015 Sean Dy. All rights reserved.
//

#import "Tweet.h"
#import "TwitterClient.h"

NSString * const kTwitterConsumerKey = @"dMn28jKZ6bOcNP3Pp17TtJwF4";
NSString * const kTwitterConsumerSecret = @"8AB2NOlMeJv3RakgI6aTrkGEeRlmJ9jK1YkysQQFp4uildyTCV";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance ==nil) {
            instance  = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    return instance;
};

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL
         ];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get requst token");
        self.loginCompletion(nil, error);
    }];
}

- (void)openUrl:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        [self.requestSerializer saveAccessToken:accessToken];
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            self.loginCompletion(user, nil);
        } failure:
         ^(AFHTTPRequestOperation *operation, NSError *error) {
             self.loginCompletion(nil, error);
         }];
    } failure:^(NSError *error) {
    }];
}

- (void)mentionsTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/mentions_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
        NSLog(@"%@",tweets);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)userTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    NSLog(@"params: %@",params);
    [self GET:@"1.1/statuses/user_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)retweetWithTweetId:(NSString *)tweetId completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json",tweetId] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(nil,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)toggleFavoriteWithParams:(NSDictionary *)params endpoint:(NSString *)endpoint completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self POST:[NSString stringWithFormat:@"1.1/favorites/%@.json",endpoint] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // No op.  All data passed in parasms
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(nil, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)composeTweetWithParameters:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self POST:@"1.1/statuses/update.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //?
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(nil, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}


@end
//
//     POST:@"1.1/statuses/retweet/:id.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//         NSArray *tweets = [Tweet tweetsWithArray:responseObject];
//         completion(tweets, nil);
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         completion(nil, error);
//     }];
    
//
//[[TwitterClient sharedInstance] GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//    
//    NSArray *tweets = [Tweet tweetsWithArray:responseObject];
//    for (Tweet *tweet in tweets) {
//        NSLog(@"tweet:%@, created, %@", tweet.text, tweet.createdAt);
//    }
//} failure:
// ^(AFHTTPRequestOperation *operation, NSError *error) {
// }];


