//
//  TweetCell.m
//  Twitter
//
//  Created by Matt Ho on 2/8/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "NSDate+DateTools.h"
#import "UIImageView+AFNetworking.h"

@interface TweetCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TweetCell

- (IBAction)onReply:(id)sender {
    [self.delegate reply:self];
}

- (IBAction)onRetweet:(id)sender {
    [self.delegate retweet:self];
}

- (IBAction)onFavorite:(id)sender {
    [self.delegate favorite:self];
}

- (void)awakeFromNib {
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    self.tweetTextLabel.preferredMaxLayoutWidth = self.tweetTextLabel.frame.size.width;
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
    
    [self.profileImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.nameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenname];
    self.createdAtLabel.text = [NSDate timeAgoSinceDate:self.tweet.createdAt];
    self.tweetTextLabel.text = self.tweet.text;
    
    if ([self.tweet.retweetCount integerValue] == 0) {
        self.retweetCountLabel.text = @"";
    } else {
        self.retweetCountLabel.text = [self.tweet.retweetCount stringValue];
    }

    if ([self.tweet.favoriteCount integerValue] == 0) {
        self.favoriteCountLabel.text = @"";
    } else {
        self.favoriteCountLabel.text = [self.tweet.favoriteCount stringValue];
    }

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
    
    if ([self.disableAction isEqual:@1]) {
        [self.replyButton removeFromSuperview];
        [self.retweetButton removeFromSuperview];
        [self.retweetCountLabel removeFromSuperview];
        [self.favoriteButton removeFromSuperview];
        [self.favoriteCountLabel removeFromSuperview];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    [super layoutSubviews];
}

- (void)onTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.delegate openProfile:self.tweet.user];
};

@end
