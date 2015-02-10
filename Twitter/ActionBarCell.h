//
//  ActionBarCell.h
//  Twitter
//
//  Created by Matt Ho on 2/9/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class ActionBarCell;

@protocol ActionBarCellDelegate <NSObject>

- (void)reply;
- (void)retweet;
- (void)favorite;

@end

@interface ActionBarCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) id<ActionBarCellDelegate> delegate;

@end
