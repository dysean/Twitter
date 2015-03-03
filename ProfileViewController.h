//
//  ProfileViewController.h
//  Twitter
//
//  Created by Sean Dy on 3/2/15.
//  Copyright (c) 2015 Sean Dy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"

@interface ProfileViewController : UIViewController
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Tweet *tweet;
@end
