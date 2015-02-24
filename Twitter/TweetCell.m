//
//  TweetCell.m
//  Twitter
//
//  Created by Sean Dy on 2/22/15.
//  Copyright (c) 2015 Sean Dy. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "TweetViewController.h"
#import "Tweet.h"
#import "composerViewController.h"



@interface TweetCell() <TweetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userHandle;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *tweetTime;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@end

@implementation TweetCell
- (IBAction)onReply:(id)sender {
    composerViewController *vc = [[composerViewController alloc] init];
    User *user = [User currentUser];
    vc.user = user;
    vc.tweet = self.tweet;
    //don't know how to get access to navigationviewcontroller
    
}
- (IBAction)onFavorite:(id)sender {
    [self.tweet favorite];
    self.retweetButton.selected = self.tweet.retweeted;
}
- (IBAction)onRetweet:(id)sender {
    [self.tweet retweet];
    self.favoriteButton.selected = self.tweet.favorited;
}

- (void)awakeFromNib {
    // Initialization code
    //some command for estimated size for textbox??
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateSelected];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet{
    _tweet = tweet;
    self.userName.text = tweet.user.name;
    self.userHandle.text = [NSString stringWithFormat:@"@%@",tweet.user.screenname];
    NSLog(@"tweet user object: %@",tweet.user);
    NSLog(@"tweet user url: %@",tweet.user.profileImageUrl);
    self.tweetText.text = tweet.text;
    [self.userImage setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
    self.tweetTime.text = tweet.createdAtWithFormat;
    self.retweetButton.selected = tweet.retweeted;
    self.favoriteButton.selected = tweet.favorited;
}

@end
