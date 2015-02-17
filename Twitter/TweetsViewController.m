//
//  TweetsViewController.m
//  Twitter
//
//  Created by Matt Ho on 2/8/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import "TweetsViewController.h"
#import "TweetViewController.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "User.h"
#import "TweetCell.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, TweetCellDelegate, UIActionSheetDelegate> {
    UIRefreshControl *refreshControl;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) TweetCell *prototypeCell;
@property (nonatomic, strong) TweetCell *untweetCell;
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

    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:42.0f/255.0f green:139.0f/255.0f blue:232.0f/255.0f alpha:1.0];
    
    // Menu
    UIImage *image = [UIImage imageNamed:@"menu"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* menuButton = [[UIButton alloc] initWithFrame:frame];
    [menuButton setBackgroundImage:image forState:UIControlStateNormal];
    [menuButton setShowsTouchWhenHighlighted:YES];
    [menuButton addTarget:self action:@selector(onMenuButton) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem* menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    [self.navigationItem setLeftBarButtonItem:menuBarButton];

    // Compose Tweet
    image = [UIImage imageNamed:@"compose"];
    frame = CGRectMake(0, 0, image.size.width, image.size.height);
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
    cell.delegate = self;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetViewController *vc = [[TweetViewController alloc] init];
    
    vc.tweet = self.tweets[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

- (void)onMenuButton {
    [self.delegate onMenuButton];
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

- (void)reply:(TweetCell *)cell {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.delegate = self;
    vc.replyTweet = cell.tweet;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)retweet:(TweetCell *)cell {
    if ([cell.tweet.retweeted isEqual:@0]) {
        [[TwitterClient sharedInstance] retweet:cell.tweet.id params:nil completion:^(Tweet *tweet, NSError *error) {
            if (tweet != nil) {
                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                [self.tweets replaceObjectAtIndex:indexPath.row withObject:tweet];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Undo retweet" otherButtonTitles:nil];
        
        self.untweetCell = cell;
        [actionSheet showInView:self.view];
    }
}

- (void)favorite:(TweetCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:cell.tweet.id forKey:@"id"];
    
    if ([cell.tweet.favorited isEqual:@0]) {
        [[TwitterClient sharedInstance] favorite:params completion:^(Tweet *tweet, NSError *error) {
            if (tweet != nil) {
                [self.tweets replaceObjectAtIndex:indexPath.row withObject:tweet];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    } else {
        [[TwitterClient sharedInstance] destroyFavorite:params completion:^(Tweet *tweet, NSError *error) {
            if (tweet != nil) {
                [self.tweets replaceObjectAtIndex:indexPath.row withObject:tweet];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    Tweet *untweet = self.untweetCell.tweet;
    
    if (untweet.retweet != nil && buttonIndex == (long) 0) {
        [[TwitterClient sharedInstance] destroy:untweet.retweet.id params:nil completion:^(Tweet *tweet, NSError *error) {
            if (tweet != nil) {
                tweet.retweeted = @0;
                tweet.retweetCount = [[NSNumber alloc] initWithInteger:([tweet.retweetCount longValue] - 1)];
                NSIndexPath *indexPath = [self.tableView indexPathForCell:self.untweetCell];
                [self.tweets replaceObjectAtIndex:indexPath.row withObject:tweet];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
}

@end
