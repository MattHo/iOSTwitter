//
//  ActionBarCell.m
//  Twitter
//
//  Created by Matt Ho on 2/9/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import "ActionBarCell.h"
#import "ComposeViewController.h"
#import "User.h"

@interface ActionBarCell()

@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation ActionBarCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    if ([self.tweet.retweeted isEqual:@1]) {
        self.retweetButton.selected = YES;
    } else {
        self.retweetButton.selected = NO;
        if ([self.tweet.user.id isEqual:[User currentUser].id]) {
            self.retweetButton.enabled = NO;
        }
    }
    
    if ([self.tweet.favorited isEqual:@1]) {
        self.favoriteButton.selected = YES;
    } else {
        self.favoriteButton.selected = NO;
    }
}

- (IBAction)onReply:(id)sender {
    [self.delegate reply];
}

- (IBAction)onRetweet:(id)sender {
    [self.delegate retweet];
}

- (IBAction)onFavorite:(id)sender {
    [self.delegate favorite];
}

@end
