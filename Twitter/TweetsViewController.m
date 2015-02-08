//
//  TweetsViewController.m
//  Twitter
//
//  Created by Matt Ho on 2/8/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import "TweetsViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "User.h"

@interface TweetsViewController ()

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        for (Tweet *tweet in tweets) {
            NSLog(@"text: %@",tweet.text);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogout:(id)sender {
    [User logout];
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
