//
//  TweetViewController.m
//  Twitter
//
//  Created by Sean Dy on 2/22/15.
//  Copyright (c) 2015 Sean Dy. All rights reserved.
//

#import "TweetViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "SingleTweetViewController.h"
#import "composerViewController.h"

@interface TweetViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tweetView;
@property (nonatomic, strong) NSArray *tweetArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TweetViewController

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweetArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = self.tweetArray[indexPath.row];
    NSLog(@"tweet cell: %@",self.tweetArray[indexPath.row]);
    NSLog(@"tweet array: %@",self.tweetArray);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelect");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SingleTweetViewController *controller = [[SingleTweetViewController alloc] init];
    controller.tweet = self.tweetArray[indexPath.row];
    
    [self.navigationController pushViewController:controller animated:YES];
}



- (void)onLogout {
    [User logout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tweetView.delegate = self;
    self.tweetView.dataSource = self;
    
    [self.tweetView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tweetView.rowHeight = UITableViewAutomaticDimension;
    self.tweetView.estimatedRowHeight = 200;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(newTweet)];
    
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
//        NSLog(@"%@",[Tweet tweetsWithArray:tweets]);
        self.tweetArray = tweets;
        [self.tweetView reloadData];
        NSLog(@"data reloaded, tweetarray: %@", tweets);
    }];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tweetView insertSubview:self.refreshControl atIndex:0];
}

- (void)newTweet {
    
    composerViewController *vc = [[composerViewController alloc] init];
    
    User *user = [User currentUser];
    vc.user = user;

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onRefresh {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.tweetArray = tweets;
        [self.tweetView reloadData];
        NSLog(@"data reloaded, tweetarray: %@", tweets);
    }];

    NSLog((@"refreshing"));
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
