//
//  GroupTableViewCell.h
//  OutlineView
//
//  Created by xhw on 16/5/9.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"

@interface GroupTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setData:(GroupModel *)groupInfo;

@end
