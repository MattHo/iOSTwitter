//
//  TweetsViewController.h
//  Twitter
//
//  Created by Matt Ho on 2/8/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol TweetsViewControllerDelegate <NSObject>

- (void)onMenuButton;
- (void)openProfile:(User *)user;

@end

@interface TweetsViewController : UIViewController

@property (nonatomic, weak) id<TweetsViewControllerDelegate> delegate;

@end
