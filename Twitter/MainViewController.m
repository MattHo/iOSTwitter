//
//  MainViewController.m
//  Twitter
//
//  Created by Matt Ho on 2/15/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import "MainViewController.h"
#import "MenuViewController.h"
#import "ProfileViewController.h"
#import "TweetsViewController.h"
#import "AccountViewController.h"
#import "User.h"

@interface MainViewController () <MenuViewDelegate, TweetsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) UINavigationController *menuViewController;
@property (nonatomic, strong) UINavigationController *contentViewController;
@property (nonatomic, assign) NSString *currentView;
@property (nonatomic, assign) NSNumber *isMenuOpen;

@end

@implementation MainViewController

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    CGFloat offset = ([self.isMenuOpen isEqual:@1]) ? -200 : 0;
    
    if ((translation.x >= (0 + offset)) && (translation.x <= (200 + offset))) {
        CGRect frame = self.contentViewController.view.frame;
        frame.origin.x = (translation.x - offset);
        self.contentViewController.view.frame = frame;
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [sender velocityInView:self.view];
        
        if (velocity.x > 0) {
            [self openMenu];
        } else if (velocity.x < 0) {
            [self closeMenu];
        }
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isMenuOpen = 0;
    
    MenuViewController *menuViewController = [[MenuViewController alloc] init];
    menuViewController.delegate = self;
    
    self.menuViewController = [[UINavigationController alloc] initWithRootViewController:menuViewController];
    self.menuViewController.view.frame = self.contentView.frame;
    [self.contentView addSubview:self.menuViewController.view];

    TweetsViewController *tweetsViewController = [[TweetsViewController alloc] init];
    tweetsViewController.delegate = self;
    self.contentViewController = [[UINavigationController alloc] initWithRootViewController:tweetsViewController];
    self.currentView = @"timelines";
    self.contentViewController.view.frame = self.contentView.frame;
    [self.contentView addSubview:self.contentViewController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)switchView:(NSString *)viewName {
    [self closeMenu];
    
    if ([viewName isEqual:@"logout"]) {
        [User logout];
    } else if ([viewName isEqual:@"profile"]) {
        [self.contentViewController.view removeFromSuperview];
        
        ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
        profileViewController.user = [User currentUser];
        self.currentView = viewName;
        self.contentViewController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
        self.contentViewController.view.frame = self.contentView.frame;
        [self.contentView addSubview:self.contentViewController.view];
    } else if (![viewName isEqual:self.currentView]) {
        [self.contentViewController.view removeFromSuperview];
        
        if ([viewName isEqual:@"timelines"]) {
            TweetsViewController *tweetsViewController = [[TweetsViewController alloc] init];
            tweetsViewController.delegate = self;
            tweetsViewController.source = @"homeTimeline";
            self.contentViewController = [[UINavigationController alloc] initWithRootViewController:tweetsViewController];
        } else if ([viewName isEqual:@"notifications"]) {
            TweetsViewController *tweetsViewController = [[TweetsViewController alloc] init];
            tweetsViewController.delegate = self;
            tweetsViewController.source = @"mentionsTimeline";
            self.contentViewController = [[UINavigationController alloc] initWithRootViewController:tweetsViewController];
        }

        self.currentView = viewName;
        self.contentViewController.view.frame = self.contentView.frame;
        [self.contentView addSubview:self.contentViewController.view];
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

- (void)openProfile:(User *)user {
    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
    profileViewController.user = user;
    [self.contentViewController.view removeFromSuperview];
    self.contentViewController = [[UINavigationController alloc] initWithRootViewController:profileViewController];

    self.currentView = @"profile";
    self.contentViewController.view.frame = self.contentView.frame;
    [self.contentView addSubview:self.contentViewController.view];
}

- (void)onMenuButton {
    if ([self.isMenuOpen isEqualToNumber:@1]) {
        [self closeMenu];
    } else {
        [self openMenu];
    }
}

- (void)openMenu {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.contentViewController.view.frame;
        frame.origin.x = 200;
        self.contentViewController.view.frame = frame;
    }];

    self.isMenuOpen = @1;
}

- (void)closeMenu {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.contentViewController.view.frame;
        frame.origin.x = 0;
        self.contentViewController.view.frame = frame;
    }];

    self.isMenuOpen = 0;
}

@end
