//
//  MainViewController.m
//  Twitter
//
//  Created by Sean Dy on 3/1/15.
//  Copyright (c) 2015 Sean Dy. All rights reserved.
//

#import "MainViewController.h"
#import "MenuCell.h"
#import "ProfileCell.h"
#import "TweetViewController.h"
#import "ProfileViewController.h"
#import "MentionsViewController.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) CGPoint mainViewOpen;
@property (nonatomic, assign) CGPoint mainViewClosed;
@property (nonatomic, assign) CGRect viewRect;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic, strong) TweetViewController *tweetViewController;
@property (nonatomic, strong) ProfileViewController *profileViewController;
@property (nonatomic, strong) MentionsViewController *mentionsViewController;

- (void)initMenu;
- (void)menuClose;
- (void)menuOpen;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMenu];

    //    self.menuView.estimatedRowHeight = 200;
    //[self.menuView reloadData];
    
    
    self.mainViewClosed = CGPointMake(187.500000, 348.500000);
    self.mainViewOpen = CGPointMake(187.500000 + 300, 348.500000);
//    self.viewRect = CGRectMake(0, 30, 320, 538);
    
    //allocate views
    self.profileViewController = [[ProfileViewController alloc] init];
    self.tweetViewController = [[TweetViewController alloc] init];
    self.mentionsViewController = [[MentionsViewController alloc] init];

    //on first load, load tweet view
    
    [self addChildViewController:self.tweetViewController];
    self.tweetViewController.view.frame = self.mainView.frame;
    [self.mainView addSubview:self.tweetViewController.view];
    [self.tweetViewController didMoveToParentViewController:self];
    
    NSLog(@"main frame x: %f, y: %f", self.mainView.frame.origin.x,self.mainView.frame.origin.y );
    NSLog(@"main size w: %f, h: %f", self.mainView.frame.size.width,self.mainView.frame.size.height);
    
    [self addChildViewController:self.tweetViewController];
    [self.tweetViewController didMoveToParentViewController:self];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuToggle)];
    
    NSLog(@"done vc stuff");
    self.menuView.delegate = self;
    self.menuView.dataSource = self;
    [self.menuView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    [self.menuView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:@"ProfileCell"];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        return 160;
    } else {
        return 43;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 3;//self.menuArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    ProfileCell *profile = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    if (indexPath.section == 0) {
        return profile;
    } else if (indexPath.section == 1) {
        cell.menuTitle.text = self.menuArray[indexPath.row][@"name"];
        NSLog(@"%@",self.menuArray[indexPath.row][@"name"]);
        //    cell.delegate = self;
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"section: %ld, row %ld", indexPath.section, indexPath.row);
    [self menuClose];
    [self.tweetViewController willMoveToParentViewController:nil];
    [self.tweetViewController.view removeFromSuperview];
    [self.tweetViewController removeFromParentViewController];
    
    [self.profileViewController willMoveToParentViewController:nil];
    [self.profileViewController.view removeFromSuperview];
    [self.profileViewController removeFromParentViewController];
    
    [self.mentionsViewController willMoveToParentViewController:nil];
    [self.mentionsViewController.view removeFromSuperview];
    [self.mentionsViewController removeFromParentViewController];
    
    if (indexPath.section == 0) {

        self.profileViewController.view.frame = self.mainView.frame;
        [self addChildViewController:self.profileViewController];
        [self.mainView addSubview:self.profileViewController.view];
        [self.tweetViewController didMoveToParentViewController:self];
        
        
    } else if (indexPath.section ==1) {
        if (indexPath.row == 0) {
            NSLog(@"did press timeline");
            self.tweetViewController.view.frame = self.mainView.frame;
            [self addChildViewController:self.tweetViewController];
            [self.mainView addSubview:self.tweetViewController.view];
            [self.tweetViewController didMoveToParentViewController:self];

        } else if (indexPath.row == 1) {
            NSLog(@"did press mentions");
            self.mentionsViewController.view.frame = self.mainView.frame;
            [self addChildViewController:self.mentionsViewController];
            [self.mainView addSubview:self.mentionsViewController.view];
            [self.mentionsViewController didMoveToParentViewController:self];
            
        } else if (indexPath.row == 2) {
            NSLog(@"did press log out");
            [User logout];
        }
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

- (void)menuToggle {
    NSLog(@"frame x:%f, frame y%f",self.mainView.frame.origin.x,self.mainView.frame.origin.y);
    NSLog(@"size h:%f,size w: %f",self.mainView.frame.size.height, self.mainView.frame.size.width);
    if (self.mainView.center.x == self.mainViewClosed.x) {
        [self menuOpen];
        
    } else if (self.mainView.center.x == self.mainViewOpen.x) {
        [self menuClose];
    }
}

- (void)menuOpen {
    NSLog(@"menu open");
    NSLog(@"x:%f, y%f",self.mainView.center.x,self.mainView.center.y);
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.center = self.mainViewOpen;
    }];
}

- (void)menuClose {
    NSLog(@"menu close");
    NSLog(@"x:%f, y%f",self.mainView.center.x,self.mainView.center.y);
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.center = self.mainViewClosed;
    }];
}

- (IBAction)viewSwipeRight:(UISwipeGestureRecognizer *)sender {
    NSLog(@"swipe right");
    [self menuOpen];
}

- (IBAction)viewSwipeLeft:(UISwipeGestureRecognizer *)sender {
    NSLog(@"swipe left");
    [self menuClose];
}

#pragma mark - Private Methods

- (void)initMenu {
    self.menuArray = @[@{@"name":@"Timeline", @"option":@"timeline"},
                       @{@"name":@"Mentions", @"option":@"mentions"},
                       @{@"name":@"Log Out", @"option":@"logout"}];
}

@end
