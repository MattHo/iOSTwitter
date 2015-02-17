//
//  ProfileDetailCell.h
//  Twitter
//
//  Created by Matt Ho on 2/15/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol ProfileDetailCellDelegate <NSObject>

- (void)onPageControlChanged:(UIPageControl *)sender;

@end

@interface ProfileDetailCell : UITableViewCell

@property (nonatomic, weak) id<ProfileDetailCellDelegate> delegate;
@property (nonatomic, strong) User *user;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
