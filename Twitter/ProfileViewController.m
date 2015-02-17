//
//  ProfileViewController.m
//  Twitter
//
//  Created by Matt Ho on 2/15/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import "ProfileViewController.h"
#import "GPUImage.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "ProfileDetailCell.h"
#import "TweetCell.h"
#import "AccountViewController.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, ProfileDetailCellDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) NSMutableArray *userTweets;
@property (nonatomic, strong) NSMutableArray *mediaTweets;
@property (nonatomic, strong) NSMutableArray *mentionsTweets;
@property (nonatomic, strong) NSMutableArray *currentTweets;
@property (nonatomic, strong) TweetCell *prototypeCell;
@property (nonatomic, assign) ProfileDetailCell *profileCell;

@end

@implementation ProfileViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self.backgroundImageView setImageWithURL:[NSURL URLWithString:self.user.backgroundImageUrl]];
    [self fetchTweets];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.userTweets = [NSMutableArray array];
    self.mediaTweets = [NSMutableArray array];
    self.mentionsTweets = [NSMutableArray array];
    self.currentTweets = self.userTweets;

    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileDetailCell" bundle:nil] forCellReuseIdentifier:@"ProfileDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view bringSubviewToFront:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 1 : self.currentTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.profileCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileDetailCell"];
        self.profileCell.user = self.user;
        self.profileCell.delegate = self;
        [self.profileCell setLayoutMargins:UIEdgeInsetsZero];
        
        return self.profileCell;
    } else if (self.currentTweets.count == 0) {
        return nil;
    } else {
         TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
         cell.tweet = self.currentTweets[indexPath.row];
         [cell setLayoutMargins:UIEdgeInsetsZero];
         
         return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGSize size = [self.profileCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height + 1;
    } else {
        self.prototypeCell.tweet = self.currentTweets[indexPath.row];
        CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height + 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section > 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat offset = scrollView.contentOffset.y;

    if (offset <= -80.0) {
        AccountViewController *vc = [[AccountViewController alloc] init];
        vc.profileViewController = self;
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromBottom;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController pushViewController:vc animated:NO];

        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:42.0f/255.0f green:139.0f/255.0f blue:232.0f/255.0f alpha:1.0];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.Hidden = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    
    if (offset >= 0.0 && offset <= 24.0) {
        // Move up background image
        CGRect frame = self.backgroundImageView.frame;
        frame.origin.y = 0 - offset;
        self.backgroundImageView.frame = frame;
        
        // Delegate to ProfileDetailCell to shrink the thumbnail image
        [self.profileCell scrollViewDidScroll:scrollView];
    }

    if (offset <= 0 && offset >= -200.0) {
        if (self.backgroundImage == nil) {
            self.backgroundImage = self.backgroundImageView.image;
        }

        if (offset <= -80.0) {
            GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
            blurFilter.blurRadiusInPixels = 1.0 - offset * 0.02;
            UIImage *blurImage = [blurFilter imageByFilteringImage:self.backgroundImage];
            self.backgroundImageView.image = blurImage;
        } else {
            self.backgroundImageView.image = self.backgroundImage;
        }

        CGFloat scale = 1 - 0.03 * offset;
        self.backgroundImageView.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

#pragma mark - Private methods
- (void)onPageControlChanged:(UIPageControl *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        if (sender.currentPage == 0) {
            self.backgroundImageView.alpha = 1;
        } else {
            self.backgroundImageView.alpha = 0.5;
        }
    }];
}

- (void)fetchTweets {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.user.id forKey:@"user_id"];
    [self.userTweets removeAllObjects];
    
    [[TwitterClient sharedInstance] userTimelineWithParams:params completion:^(NSArray *tweets, NSError *error) {
        [self.userTweets addObjectsFromArray:tweets];
        self.currentTweets = self.userTweets;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }];

    [[TwitterClient sharedInstance] mentionsTimelineWithParams:params completion:^(NSArray *tweets, NSError *error) {
        [self.mentionsTweets addObjectsFromArray:tweets];
    }];
}

- (TweetCell *) prototypeCell {
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    }
    return _prototypeCell;
}

@end
