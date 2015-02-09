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

@end

@implementation TweetCell

- (void)awakeFromNib {
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    self.tweetTextLabel.preferredMaxLayoutWidth = self.tweetTextLabel.frame.size.width;
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
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
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    [super layoutSubviews];
}

@end
