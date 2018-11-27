//
//  ItemTableViewCell.h
//  OutlineView
//
//  Created by xhw on 16/5/9.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"

@interface ItemTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setData:(ItemModel *)itemInfo;

@end
