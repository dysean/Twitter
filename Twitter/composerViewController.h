//
//  composerViewController.h
//  Twitter
//
//  Created by Sean Dy on 2/23/15.
//  Copyright (c) 2015 Sean Dy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"

@interface composerViewController : UIViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Tweet *tweet;


@end
