//
//  ItemTableViewCell.m
//  OutlineView
//
//  Created by xhw on 16/5/9.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "ItemTableViewCell.h"
#import "UIView+Extension.h"

@interface ItemTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UIImageView *selectStatusView;

@property (nonatomic, strong) ItemModel *itemInfo;

@end

@implementation ItemTableViewCell

#pragma mark - init
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"ItemTableViewCell";
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addAllSubviews];
    }
    return self;
}

- (void)addAllSubviews {
    [self addSubview:self.selectStatusView];
    [self addSubview:self.iconView];
    [self addSubview:self.nameLabel];
}

- (void)setData:(ItemModel *)itemInfo
{
    self.itemInfo = itemInfo;
    
    self.nameLabel.text = self.itemInfo.itemName;
    switch (self.itemInfo.selectStatus)
    {
        case SelectStatusAll: {
            _selectStatusView.image = [UIImage imageNamed:@"select_ture"];
            break;
        }
        case SelectStatusNone: {
            _selectStatusView.image = [UIImage imageNamed:@"select_false"];
            break;
        }
        case SelectStatusOther: {
            _selectStatusView.image = [UIImage imageNamed:@"select_few"];
            break;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat xoffSet = 15;
    if(self.itemInfo)
    {
        xoffSet += self.itemInfo.nodeLevel * 15;
    }
    
    _selectStatusView.frame = CGRectMake(xoffSet, (self.height - 16)/2, 16, 16);
    xoffSet += 20;
    
    _iconView.frame = CGRectMake(xoffSet, (self.height - 16)/2, 16, 16);
    xoffSet += 20;
    
    _nameLabel.frame = CGRectMake(xoffSet, 0, self.width - xoffSet, self.height);
}

#pragma mark - lazy

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}

- (UIImageView *)iconView
{
    if(!_iconView)
    {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"center_defaulthead"]];
    }
    return _iconView;
}


- (UIImageView *)selectStatusView
{
    if(!_selectStatusView)
    {
        _selectStatusView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_false"]];
    }
    return _selectStatusView;
}

@end
