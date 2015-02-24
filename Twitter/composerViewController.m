//
//  composerViewController.m
//  Twitter
//
//  Created by Sean Dy on 2/23/15.
//  Copyright (c) 2015 Sean Dy. All rights reserved.
//

#import "composerViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"


@interface composerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userHandle;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet NSString *replyMentions;
@property (weak, nonatomic) IBOutlet NSString *tweetId;

@end

@implementation composerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUser:self.user];
    [self setTweet:self.tweet];
    
    if(self.tweet) {
        //Reply
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(newTweet)];
        if(self.replyMentions.length>0){
            self.tweetTextView.text = self.replyMentions;
        }
        
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(newTweet)];
    }
    
    [self.tweetTextView select:self];
    // Do any additional setup after loading the view from its nib.
}

- (void)newTweet {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.tweet) {
        [params setObject:self.tweetId forKey:@"in_reply_to_status_id_str"];
    }
    [params setObject:self.tweetTextView.text forKey:@"status"];
    [[TwitterClient sharedInstance] composeTweetWithParameters:params completion:^(NSArray *tweets, NSError *error) {
        if (!error) {
            NSLog(@"tweeted");
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"failed to tweet %@", error);
        }
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUser:(User *)user {
    _user = user;
    self.userName.text = self.user.name;
    self.userHandle.text = self.user.screenname;
    [self.userImage setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
}

- (void)setTweet:(Tweet *)tweet{
    _tweet = tweet;
    NSMutableArray *mentions = [NSMutableArray arrayWithArray:[tweet.mentions valueForKey:@"screen_name"]];
    if (tweet) {
        if (![mentions containsObject:tweet.user.screenname])
            [mentions addObject:tweet.user.screenname];
        
        self.replyMentions = [NSString stringWithFormat:@"@%@", [mentions componentsJoinedByString:@" @"] ];
        self.tweetId = tweet.tweetId;
        
    }
    
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
