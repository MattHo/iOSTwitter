//
//  ProfileDetailCell.m
//  Twitter
//
//  Created by Matt Ho on 2/15/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import "ProfileDetailCell.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileDetailCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIView *profileImageContainer;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIView *summaryView;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sourceControl;

@end

@implementation ProfileDetailCell

- (void)awakeFromNib {
    self.profileImageContainer.layer.cornerRadius = 4;
    self.profileImageContainer.clipsToBounds = YES;
    self.profileImageView.layer.cornerRadius = 4;
    self.profileImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:NO];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    _user = user;
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenname];
    self.summaryLabel.text = self.user.tagline;
    self.followersLabel.text = self.user.followers;
    self.followingLabel.text = self.user.following;
}

- (IBAction)onPageControlChanged:(UIPageControl *)sender {
    if (sender.currentPage == 0) {
        CGRect infoFrame = self.infoView.frame;
        infoFrame.origin.x = 0 - infoFrame.size.width;
        self.infoView.frame = infoFrame;

        CGRect summaryFrame = self.summaryView.frame;
        summaryFrame.origin.x = 0;
        self.summaryView.frame = summaryFrame;
        
        [self bringSubviewToFront:self.infoView];
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect infoFrame = self.infoView.frame;
            infoFrame.origin.x = 0;
            self.infoView.frame = infoFrame;

            CGRect summaryFrame = self.summaryView.frame;
            summaryFrame.origin.x = summaryFrame.size.width;
            self.summaryView.frame = summaryFrame;
        }];
    } else {
        CGRect infoFrame = self.infoView.frame;
        infoFrame.origin.x = 0;
        self.infoView.frame = infoFrame;
        
        CGRect summaryFrame = self.summaryView.frame;
        summaryFrame.origin.x = summaryFrame.size.width;
        self.summaryView.frame = summaryFrame;
        
        [self bringSubviewToFront:self.summaryView];
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect infoFrame = self.infoView.frame;
            infoFrame.origin.x = 0 - infoFrame.size.width;
            self.infoView.frame = infoFrame;
            
            CGRect summaryFrame = self.summaryView.frame;
            summaryFrame.origin.x = 0;
            self.summaryView.frame = summaryFrame;
        }];
    }
    
    [self.delegate onPageControlChanged:sender];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    
    if (offset >= 0.0 && offset <= 24.0) {
        CGFloat scale = 1 - 0.015 * offset;
        self.profileImageContainer.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

@end
