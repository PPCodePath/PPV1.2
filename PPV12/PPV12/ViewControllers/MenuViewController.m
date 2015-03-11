//
//  MenuViewController.m
//  PPV12
//
//  Created by Mamuad, Christian on 3/10/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *menuView;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuView.delegate = self;
    self.menuView.dataSource = self;
    self.menuView.rowHeight = 40;
    [self.menuView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    self.menuView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title=@"Menu";
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [self.menuView dequeueReusableCellWithIdentifier:@"MenuCell"];
    switch (indexPath.row) {
        case 0:
            cell.menuTitle.text = @"Profile";
            break;
        case 1:
            cell.menuTitle.text = @"Send/Request Money";
            break;
        case 2:
            cell.menuTitle.text = @"Transactions";
            break;
        case 3:
            cell.menuTitle.text = @"Sign Out";
            break;
        default:
            cell.menuTitle.text =@"";
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            NSLog(@"Profile clicked");
            [self.delegate closeMenu:@"profile"];
            break;
        case 1:
            NSLog(@"Main clicked");
            [self.delegate closeMenu:@"main"];
            break;
        case 2:
            NSLog(@"Transaction clicked");
            [self.delegate closeMenu:@"transaction"];
            break;
        default:
            //Log Out
            break;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
