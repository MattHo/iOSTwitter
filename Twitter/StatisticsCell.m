//
//  StatisticsCell.m
//  Twitter
//
//  Created by Matt Ho on 2/9/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import "StatisticsCell.h"
#import "Tweet.h"

@interface StatisticsCell()

@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;

@end

@implementation StatisticsCell

- (void)awakeFromNib {
    self.retweetCountLabel.preferredMaxLayoutWidth = self.retweetCountLabel.frame.size.width;
    self.retweetLabel.preferredMaxLayoutWidth = self.retweetLabel.frame.size.width;
    self.favoriteCountLabel.preferredMaxLayoutWidth = self.favoriteCountLabel.frame.size.width;
    self.favoriteLabel.preferredMaxLayoutWidth = self.favoriteLabel.frame.size.width;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.retweetCountLabel.preferredMaxLayoutWidth = self.retweetCountLabel.frame.size.width;
    self.retweetLabel.preferredMaxLayoutWidth = self.retweetLabel.frame.size.width;
    self.favoriteCountLabel.preferredMaxLayoutWidth = self.favoriteCountLabel.frame.size.width;
    self.favoriteLabel.preferredMaxLayoutWidth = self.favoriteLabel.frame.size.width;
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;

    if ([self.tweet.retweetCount isEqual:@0]) {
        self.retweetCountLabel.text = nil;
        self.retweetLabel.text = nil;
    } else {
        self.retweetCountLabel.text = [self.tweet.retweetCount stringValue];
        self.retweetLabel.text = @" RETWEETS";
    }
    
    if ([self.tweet.favoriteCount isEqual:@0]) {
        self.favoriteCountLabel.text = nil;
        self.favoriteLabel.text = nil;
    } else {
        self.favoriteCountLabel.text = [self.tweet.favoriteCount stringValue];
        self.favoriteLabel.text = @" FAVORITES";
    }
}

@end
