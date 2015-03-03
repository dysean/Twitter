//
//  ProfileCell.m
//  Twitter
//
//  Created by Sean Dy on 3/2/15.
//  Copyright (c) 2015 Sean Dy. All rights reserved.
//

#import "ProfileCell.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"

@implementation ProfileCell

- (void)awakeFromNib {
    // Initialization code
    User *user = [User currentUser];
    NSLog(@"awake from nib");
    [self.profileImage setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.userNameLabel.text = user.name;
    self.userHandleLabel.text = user.screenname;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
