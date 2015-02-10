//
//  ComposeViewController.m
//  Twitter
//
//  Created by Matt Ho on 2/8/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "User.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputText;
@property (strong, nonatomic) UIBarButtonItem *countButton;
@property (strong, nonatomic) UIBarButtonItem *composeBarButton;
@property (strong, nonatomic) UIButton *composeButton;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *count = @"140";
    User *user = [User currentUser];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenname];

    if (self.replyTweet != nil) {
        self.inputText.text = [NSString stringWithFormat:@"@%@", self.replyTweet.user.screenname];
        count = [NSString stringWithFormat:@"%lu", 140 - self.inputText.text.length];
    }
    
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;

    // Navigation Button
    // Cancel
    UIImage *image = [UIImage imageNamed:@"cancel"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:YES];
    [button addTarget:self action:@selector(onCancelButton) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    
    // Compose
    NSMutableArray *buttonList = [NSMutableArray array];
    
    self.composeButton = [[UIButton alloc] init];
    self.composeButton.frame = CGRectMake(10, 0, 30, 30);
    self.composeButton.layer.backgroundColor = [UIColor colorWithRed:42.0f/255.0f green:139.0f/255.0f blue:232.0f/255.0f alpha:0.5].CGColor;
    self.composeButton.layer.cornerRadius = 7.5f;
    [self.composeButton setShowsTouchWhenHighlighted:YES];
    [self.composeButton setTitle:@"Tweet" forState:UIControlStateNormal];
    [self.composeButton addTarget:self action:@selector(onComposeButton) forControlEvents:UIControlEventTouchDown];
    self.composeButton.frame = CGRectMake(0, 0, 70.0, 30.0);

    self.composeBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.composeButton];
    self.composeBarButton.enabled = NO;
    
    self.countButton = [[UIBarButtonItem alloc] initWithTitle:count style:UIBarButtonItemStylePlain target:self action:nil];
    self.countButton.enabled = NO;

    [buttonList addObject:self.composeBarButton];
    [buttonList addObject:self.countButton];
    self.navigationItem.rightBarButtonItems = buttonList;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (IBAction)editingChanged:(id)sender {
    if (self.inputText.text.length == 0) {
        [UIView setAnimationsEnabled:NO];
        [self.countButton setTitle:[NSString stringWithFormat:@"%lu", (long) 140]];
        [UIView setAnimationsEnabled:YES];

        self.countButton.enabled = NO;
        self.composeBarButton.enabled = NO;
        self.composeButton.layer.backgroundColor = [UIColor colorWithRed:42.0f/255.0f green:139.0f/255.0f blue:232.0f/255.0f alpha:0.5].CGColor;
    } else {
        if (self.countButton.enabled == NO) {
            self.countButton.enabled = YES;
        }
        
        [UIView setAnimationsEnabled:NO];
        [self.countButton setTitle:[NSString stringWithFormat:@"%lu", 140 - self.inputText.text.length]];
        [UIView setAnimationsEnabled:YES];

        if (self.composeBarButton.enabled == NO) {
            self.composeBarButton.enabled = YES;
            self.composeButton.layer.backgroundColor = [UIColor colorWithRed:42.0f/255.0f green:139.0f/255.0f blue:232.0f/255.0f alpha:1.0].CGColor;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onComposeButton {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.inputText.text forKey:@"status"];
    
    if (self.replyTweet != nil) {
        [params setValue:self.replyTweet.id forKey:@"in_reply_to_status_id"];
    }

    [[TwitterClient sharedInstance] compose:params completion:^(Tweet *tweet, NSError *error) {
        if (tweet != nil) {
            if (self.replyTweet != nil) {
                self.replyTweet.replyTweet = tweet;
                [self.delegate composeViewController:self didComposeTweet:self.replyTweet];
            } else {
                [self.delegate composeViewController:self didComposeTweet:tweet];
            }
        }

        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
