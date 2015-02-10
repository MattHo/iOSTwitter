//
//  TweetViewController.m
//  Twitter
//
//  Created by Matt Ho on 2/9/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import "TweetViewController.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "TweetDetailCell.h"
#import "ActionBarCell.h"
#import "StatisticsCell.h"

@interface TweetViewController () <UITableViewDataSource, UITableViewDelegate, ActionBarCellDelegate, ComposeViewControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TweetDetailCell *prototypeCell;
@property (nonatomic, strong) TweetCell *prototypeTweetCell;
@property (nonatomic, strong) StatisticsCell *prototypeStatisticsCell;
@property (nonatomic, strong) ActionBarCell *prototypeAutoBarCell;

@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tweet";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetDetailCell" bundle:nil] forCellReuseIdentifier:@"TweetDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StatisticsCell" bundle:nil] forCellReuseIdentifier:@"StatisticsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActionBarCell" bundle:nil] forCellReuseIdentifier:@"ActionBarCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];

    // Compose Tweet
    UIImage *image = [UIImage imageNamed:@"compose"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:YES];
    [button addTarget:self action:@selector(onComposeButton) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.tweet.replyTweet == nil) ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self showStatistics] ? 3 : 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BOOL showStatistics = [self showStatistics];
        
        if (indexPath.row == 0) {
            TweetDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetDetailCell"];
            cell.tweet = self.tweet;
            return cell;
        } else if (indexPath.row == 1 && showStatistics) {
            StatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatisticsCell"];
            cell.tweet = self.tweet;
            return cell;
        } else if ((indexPath.row == 1 && !showStatistics) || indexPath.row == 2) {
            ActionBarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActionBarCell"];
            cell.tweet = self.tweet;
            cell.delegate = self;
            return cell;
        }
    } else {
        TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
        cell.tweet = self.tweet.replyTweet;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BOOL showStatistics = [self showStatistics];
        
        if (indexPath.row == 0) {
            self.prototypeCell.tweet = self.tweet;
            CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            return size.height + 1;
        } else if (indexPath.row == 1 && showStatistics) {
            self.prototypeStatisticsCell.tweet = self.tweet;
            CGSize size = [self.prototypeStatisticsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            return size.height + 1;
        } else if ((indexPath.row == 1 && !showStatistics) || indexPath.row == 2) {
            self.prototypeAutoBarCell.tweet = self.tweet;
            CGSize size = [self.prototypeAutoBarCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            return size.height + 1;
        }
    } else {
        self.prototypeTweetCell.tweet = self.tweet.replyTweet;
        CGSize size = [self.prototypeTweetCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height + 1;
    }
    
    return 0.0;
}

- (TweetDetailCell *) prototypeCell {
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetDetailCell"];
    }
    return _prototypeCell;
}

- (TweetCell *) prototypeTweetCell {
    if (!_prototypeTweetCell) {
        _prototypeTweetCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    }
    return _prototypeTweetCell;
}

- (StatisticsCell *) prototypeStatisticsCell {
    if (!_prototypeStatisticsCell) {
        _prototypeStatisticsCell = [self.tableView dequeueReusableCellWithIdentifier:@"StatisticsCell"];
    }
    return _prototypeStatisticsCell;
}

- (ActionBarCell *) prototypeAutoBarCell {
    if (!_prototypeAutoBarCell) {
        _prototypeAutoBarCell = [self.tableView dequeueReusableCellWithIdentifier:@"ActionBarCell"];
    }
    return _prototypeAutoBarCell;
}

- (void)onComposeButton {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (BOOL) showStatistics {
    return !([self.tweet.retweetCount isEqual:@0] && [self.tweet.favoriteCount isEqual:@0]);
}

- (void)composeViewController:(ComposeViewController *)composeViewController didComposeTweet:(Tweet *)tweet {
    self.tweet = tweet;
    [self.tableView reloadData];
}

#pragma mark - ActionBar cell delegate methods

- (void)reply {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.delegate = self;
    vc.replyTweet = self.tweet;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)retweet {
    if ([self.tweet.retweeted isEqual:@0]) {
        [[TwitterClient sharedInstance] retweet:self.tweet.id params:nil completion:^(Tweet *tweet, NSError *error) {
            if (tweet != nil) {
                self.tweet = tweet;
                [self.tableView reloadData];
            }
        }];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Undo retweet" otherButtonTitles:nil];
        
        [actionSheet showInView:self.view];
    }
}

- (void)favorite {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.tweet.id forKey:@"id"];                                           
    
    if ([self.tweet.favorited isEqual:@0]) {
        [[TwitterClient sharedInstance] favorite:params completion:^(Tweet *tweet, NSError *error) {
            if (tweet != nil) {
                self.tweet = tweet;
                [self.tableView reloadData];
            }
        }];
    } else {
        [[TwitterClient sharedInstance] destroyFavorite:params completion:^(Tweet *tweet, NSError *error) {
            if (tweet != nil) {
                self.tweet = tweet;
                [self.tableView reloadData];
            }
        }];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.tweet.retweet != nil && buttonIndex == (long) 0) {
        [[TwitterClient sharedInstance] destroy:self.tweet.retweet.id params:nil completion:^(Tweet *tweet, NSError *error) {
            if (tweet != nil) {
                self.tweet = tweet;
                self.tweet.retweeted = @0;
                self.tweet.retweetCount = [[NSNumber alloc] initWithInteger:([self.tweet.retweetCount longValue] - 1)];
                [self.tableView reloadData];
            }
        }];
    }
}

@end
