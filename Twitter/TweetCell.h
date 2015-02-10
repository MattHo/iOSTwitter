//
//  TweetCell.h
//  Twitter
//
//  Created by Matt Ho on 2/8/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetCell;

@protocol TweetCellDelegate <NSObject>

- (void)reply:(TweetCell *)cell;
- (void)retweet:(TweetCell *)cell;
- (void)favorite:(TweetCell *)cell;

@end

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, strong) NSNumber *disableAction;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;

@end
