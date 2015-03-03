//
//  ProfileViewController.m
//  Twitter
//
//  Created by Sean Dy on 3/2/15.
//  Copyright (c) 2015 Sean Dy. All rights reserved.
//

#import "ProfileViewController.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "SingleTweetViewController.h"
#import "composerViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tweetView;
@property (nonatomic, strong) NSArray *tweetArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numTweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowersLabel;
@property (assign, nonatomic) CGPoint headerOriginalCenter;
@end

@implementation ProfileViewController

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweetArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTweetCell"];
    cell.tweet = self.tweetArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return 156;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SingleTweetViewController *controller = [[SingleTweetViewController alloc] init];
    controller.tweet = self.tweetArray[indexPath.row];
    
    [self.navigationController pushViewController:controller animated:YES];
}



- (void)onLogout {
    [User logout];
}

- (void)viewWillAppear:(BOOL)animated {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.tweet) {
        [params setObject:self.tweet.user.idString forKey:@"user_id"];
    }
    [[TwitterClient sharedInstance] userTimelineWithParams:params completion:^(NSArray *tweets, NSError *error) {
        self.tweetArray = tweets;
        [self.tweetView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUser:self.user];
    [self setTweet:self.tweet];
    
//    self.headerOriginalCenter = self.headerView.center;
    
    self.title = @"Twitter";
    // Do any additional setup after loading the view from its nib.
    self.tweetView.delegate = self;
    self.tweetView.dataSource = self;
    
    [self.tweetView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"ProfileTweetCell"];
    self.tweetView.rowHeight = UITableViewAutomaticDimension;
    self.tweetView.estimatedRowHeight = 200;

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(newTweet)];
    
    [[TwitterClient sharedInstance] userTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.tweetArray = tweets;
        [self.tweetView reloadData];
    }];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tweetView insertSubview:self.refreshControl atIndex:0];
}


//fix this
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"scrolling");
//    [UIView animateWithDuration:0.3 animations:^{
//        self.headerView.center = CGPointMake(self.headerOriginalCenter.x, self.headerOriginalCenter.y -500);
//    }];
//}



- (void)newTweet {
    
    composerViewController *vc = [[composerViewController alloc] init];
    
    User *user = [User currentUser];
    vc.user = user;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onRefresh {
    [[TwitterClient sharedInstance] userTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.tweetArray = tweets;
        [self.tweetView reloadData];
    }];
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setTweet:(Tweet *)tweet{
    _tweet = tweet;
    if (tweet) {
        [self.userImageView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
        self.userNameLabel.text = tweet.user.name;
        self.userHandleLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenname ];
        self.numTweetsLabel.text = [NSString stringWithFormat:@"Tweets: %ld", tweet.user.tweetCount];
        self.numFollowingLabel.text = [NSString stringWithFormat:@"Following: %ld", tweet.user.followingCount];
        self.numFollowersLabel.text = [NSString stringWithFormat:@"Followers: %ld", tweet.user.followersCount];
    } else {
        User *user = [User currentUser];
        [self.userImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
        self.userNameLabel.text = user.name;
        self.userHandleLabel.text = [NSString stringWithFormat:@"@%@", user.screenname ];
        self.numTweetsLabel.text = [NSString stringWithFormat:@"Tweets: %ld", user.tweetCount];
        self.numFollowingLabel.text = [NSString stringWithFormat:@"Following: %ld", user.followingCount];
        self.numFollowersLabel.text = [NSString stringWithFormat:@"Followers: %ld", user.followersCount];
    }
    
}


#pragma mark - Tweet Cell Delegate

- (void)tweetcell:(TweetCell *)tweetcell pressButton:(NSString *)button{
// no implementation of delegate
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end

