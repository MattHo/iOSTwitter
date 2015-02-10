//
//  TweetDetailCell.m
//  Twitter
//
//  Created by Matt Ho on 2/9/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import "TweetDetailCell.h"
#import "Tweet.h"
#import "NSDate+DateTools.h"
#import "UIImageView+AFNetworking.h"

@interface TweetDetailCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;

@end

@implementation TweetDetailCell

- (void)awakeFromNib {
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
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
    self.tweetLabel.text = self.tweet.text;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    [super layoutSubviews];
}

@end
