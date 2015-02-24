//
//  User.h
//  Twitter
//
//  Created by Sean Dy on 2/22/15.
//  Copyright (c) 2015 Sean Dy. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;


@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (void)logout;
+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;

@end
