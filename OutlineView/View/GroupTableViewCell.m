//
//  GroupTableViewCell.m
//  OutlineView
//
//  Created by xhw on 16/5/9.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "GroupTableViewCell.h"
#import "UIView+Extension.h"
#import "TreeViewController.h"

@interface GroupTableViewCell ()

@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UIButton          *arrowBtn;//展开按钮
@property (nonatomic, strong) UIImageView       *iconView;//组标志
@property (nonatomic, strong) UIImageView       *selectStatusView;//选择状态

@property (nonatomic, strong) GroupModel        *groupInfo;

@end

@implementation GroupTableViewCell

#pragma mark - init
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"GroupTableViewCell";
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[GroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
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
    [self addSubview:self.arrowBtn];
}

- (void)setData:(GroupModel *)groupInfo
{
    self.groupInfo = groupInfo;
    
    self.nameLabel.text = self.groupInfo.groupName;
    
    if(self.groupInfo.isExpanded)
    {
        [_arrowBtn setTitle:@"-" forState:UIControlStateNormal];
        
    }
    else
    {
        [_arrowBtn setTitle:@"+" forState:UIControlStateNormal];
    }
    
    switch (self.groupInfo.selectStatus)
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
    if(self.groupInfo)
    {
        xoffSet += self.groupInfo.nodeLevel * 15;
    }
    
    _selectStatusView.frame = CGRectMake(xoffSet, (self.height - 16)/2, 16, 16);
    xoffSet += 20;
    
    _iconView.frame = CGRectMake(xoffSet, (self.height - 16)/2, 16, 16);
    xoffSet += 20;

    _nameLabel.frame = CGRectMake(xoffSet, 0, self.width - xoffSet, self.height);
    
    _arrowBtn.frame = CGRectMake(self.width - 15 - self.height, 0, self.height, self.height);
}

- (void)arrowBtnAction
{
    self.groupInfo.isExpanded = !self.groupInfo.isExpanded;
    [(TreeViewController *)self.viewController reloadDisplayArray];
}

#pragma mark - lazy

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}

- (UIButton *)arrowBtn {
    if (!_arrowBtn) {
        _arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowBtn setTitle:@"+" forState:UIControlStateNormal];
        [_arrowBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _arrowBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        [_arrowBtn addTarget:self action:@selector(arrowBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowBtn;
}

- (UIImageView *)iconView
{
    if(!_iconView)
    {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"general_nextlevel"]];
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
