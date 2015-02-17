//
//  AccountViewController.m
//  Twitter
//
//  Created by Matt Ho on 2/16/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import "AccountViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "AccountCell.h"
#import "AddAccountCell.h"

@interface AccountViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray* userList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Account";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:42.0f/255.0f green:139.0f/255.0f blue:232.0f/255.0f alpha:1.0];

    [self initUserList];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountCell" bundle:nil] forCellReuseIdentifier:@"AccountCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddAccountCell" bundle:nil] forCellReuseIdentifier:@"AddAccountCell"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.userList.count) {
        AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddAccountCell"];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        return cell;
    } else {
        AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCell"];
        cell.user = self.userList[indexPath.row];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cells = self.userList.count + 1;
    return self.view.frame.size.height / cells;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.userList.count) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Create new account", @"Add an existing account", nil];
        
        [actionSheet showInView:self.view];
    } else {
        User *selectedUser = self.userList[indexPath.row];
        [User setCurrentUser:selectedUser];
        
        self.profileViewController.user = selectedUser;
        
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBar.Hidden = YES;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 || buttonIndex == 1) {
        [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
            [self initUserList];
        }];
    }
}

-(void)initUserList {
    self.userList = [NSMutableArray array];
    NSDictionary *userPool = [User userPool];
    for (NSString* userId in userPool) {
        [self.userList addObject:[userPool valueForKey:userId]];
    }

    [self.tableView reloadData];
}

@end
