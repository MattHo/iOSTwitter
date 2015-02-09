//
//  TweetsViewController.m
//  Twitter
//
//  Created by Matt Ho on 2/8/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import "TweetsViewController.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "User.h"
#import "TweetCell.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate> {
    UIRefreshControl *refreshControl;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) TweetCell *prototypeCell;
@property (nonatomic, strong) NSMutableDictionary *params;

@end

@implementation TweetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self fetchTweets];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"Home"];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Compose Tweet
    UIImage *image = [UIImage imageNamed:@"compose"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:YES];
    [button addTarget:self action:@selector(onComposeButton) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
    
    // Refresh
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

    // Infinite Scroll
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = tableFooterView.center;
    [tableFooterView addSubview:loadingView];
    self.tableView.tableFooterView = tableFooterView;
    self.tableView.tableFooterView.hidden = YES;
    
    self.params = [NSMutableDictionary dictionary];
    self.tweets = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = self.tweets[indexPath.row];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    
    if (indexPath.row == self.tweets.count - 1 && self.tweets.count < 100) {
        self.tableView.tableFooterView.hidden = NO;
        [self.params setValue:cell.tweet.id forKey:@"max_id"];
        [self.params setValue:nil forKey:@"since_id"];
        [self fetchTweets];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeCell.tweet = self.tweets[indexPath.row];
    
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height + 1;
}

#pragma mark - Private methods
- (void)fetchTweets {
    [[TwitterClient sharedInstance] homeTimelineWithParams:self.params completion:^(NSArray *tweets, NSError *error) {
        [self.tweets addObjectsFromArray:tweets];
        [self.tableView reloadData];
        self.tableView.tableFooterView.hidden = YES;
    }];
}

- (TweetCell *) prototypeCell {
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    }
    return _prototypeCell;
}

- (void)onComposeButton {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
 }

- (void)refresh:(id)sender {
    Tweet *tweet = self.tweets[0];
    [self.params setValue:nil forKey:@"max_id"];
    [self.params setValue:tweet.id forKey:@"since_id"];

    [[TwitterClient sharedInstance] homeTimelineWithParams:self.params completion:^(NSArray *tweets, NSError *error) {
        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [tweets count])];
        [self.tweets insertObjects:tweets atIndexes:indexes];
        [self.tableView reloadData];
        [(UIRefreshControl *)sender endRefreshing];
    }];
}

- (void)composeViewController:(ComposeViewController *)composeViewController didComposeTweet:(Tweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

@end
