//
//  SingleTweetViewController.m
//  Twitter
//
//  Created by Sean Dy on 2/23/15.
//  Copyright (c) 2015 Sean Dy. All rights reserved.
//

#import "SingleTweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TweetViewController.h"
#import "composerViewController.h"
//#import "Tweet.h"

@interface SingleTweetViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userHandle;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *tweetTime;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@end

@implementation SingleTweetViewController

- (IBAction)onReply:(id)sender {
    composerViewController *vc = [[composerViewController alloc] init];
    User *user = [User currentUser];
    vc.user = user;
    vc.tweet = self.tweet;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)onFavorite:(id)sender {
    [self.tweet favorite];
    self.retweetButton.selected = self.tweet.retweeted;
}
- (IBAction)onRetweet:(id)sender {
    [self.tweet retweet];
    self.favoriteButton.selected = self.tweet.favorited;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tweet";
    NSLog(@"View did load");
    [self setTweet:self.tweet];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateSelected];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateSelected];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
