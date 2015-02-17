//
//  AccountCell.m
//  Twitter
//
//  Created by Matt Ho on 2/16/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import "AccountCell.h"
#import "UIImageView+AFNetworking.h"
#import "GPUImage.h"
#import "User.h"

@interface AccountCell()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *profileImageContainer;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;


@end

@implementation AccountCell

- (void)awakeFromNib {
    self.profileImageContainer.layer.cornerRadius = 3;
    self.profileImageContainer.clipsToBounds = YES;
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;

    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [blurView setFrame:self.bounds];
    [self.backgroundImageView addSubview:blurView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    NSArray *subViews = [self.backgroundImageView subviews];
    for (NSInteger i = 0; i < subViews.count; i++) {
        UIView *view = subViews[i];
        [view removeFromSuperview];
    }

    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [blurView setFrame:self.bounds];
    [self.backgroundImageView addSubview:blurView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    _user = user;
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenname];
    
    [self.backgroundImageView setImageWithURL:[NSURL URLWithString:self.user.backgroundImageUrl]];
}

@end
