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



@interface TweetCell() <TweetCellDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userHandle;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *tweetTime;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@end

@implementation TweetCell

- (void)tweetcell:(TweetCell *)tweetcell pressButton:(NSString *)button{
}

- (IBAction)onReply:(id)sender {
    [self.delegate tweetcell:self pressButton:@"reply"];
}
- (IBAction)onFavorite:(id)sender {
    [self.tweet favorite];
    self.retweetButton.selected = self.tweet.retweeted;
}
- (IBAction)onRetweet:(id)sender {
    [self.tweet retweet];
    self.favoriteButton.selected = self.tweet.favorited;
}

- (void)imgTap {
    [self.delegate tweetcell:self pressButton:@"profileImg"];
}

- (void)awakeFromNib {
    // Initialization code
    //some command for estimated size for textbox??
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateSelected];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateSelected];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    [self.userImage addGestureRecognizer:tap];
    [self.userImage setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet{
    _tweet = tweet;
    self.userName.text = tweet.user.name;
    self.userHandle.text = [NSString stringWithFormat:@"@%@",tweet.user.screenname];
    self.tweetText.text = tweet.text;
    [self.userImage setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
    self.tweetTime.text = tweet.createdAtWithFormat;
    self.retweetButton.selected = tweet.retweeted;
    self.favoriteButton.selected = tweet.favorited;
}

@end
