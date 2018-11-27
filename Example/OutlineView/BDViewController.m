//
//  ViewController.m
//  OutlineView
//
//  Created by xhw on 16/5/9.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "BDViewController.h"
#import "JTTree.h"
#import "ItemModel.h"
#import "GroupModel.h"
#import "UIView+Extension.h"
#import "TreeViewController.h"

@interface BDViewController ()<TreeViewControllerDelegate>
{
    UILabel *selectedIdLable;
}

@end

@implementation BDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 100, self.view.width, 30);
    btn.tag = 1;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"随机创建树形结构数据" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 150, self.view.width, 30);
    btn.tag = 2;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"从json解析出树形结构(todo)" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 200, self.view.width, 30);
    btn.tag = 3;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"根据选中的id还原界面数据(todo)" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    selectedIdLable = [[UILabel alloc] init];
    selectedIdLable.frame = CGRectMake(0, 250, self.view.width, 100);
    selectedIdLable.font = [UIFont systemFontOfSize:14];
    selectedIdLable.textAlignment = NSTextAlignmentCenter;
    selectedIdLable.numberOfLines = 0;
    [self.view addSubview:selectedIdLable];
    
}

- (void)btnAction:(UIButton *)sender
{
    if(sender.tag == 1)
    {
        NSArray *array = [self randomData];
        TreeViewController *ctrl = [[TreeViewController alloc] initWithData:array];
        ctrl.delegate = self;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

#pragma mark - TreeViewControllerDelegate
- (void)treeViewController:(TreeViewController *)vc didChangeSelected:(NSString *)selectedId
{
    selectedIdLable.text = selectedId;
}


#pragma mark - 创建随机树形结构
- (NSMutableArray *)randomData
{
    NSMutableArray *result = [NSMutableArray array];
    for(int i = 0; i < 8 ; i++)
    {
        BOOL random = arc4random() % 2;
        id node = [self creatNode:random withParentNode:nil withIndex:i];
        
        JTTree *tree = [JTTree treeWithObject:node];
        [result addObject:tree];
        
        if(((BaseModel *)node).nodeType == NodeTypeGroup)
        {
            [self addRandomNodesToParent:tree];
        }
    }
    
    return result;
}

- (id)creatNode:(BOOL)isGroup withParentNode:(GroupModel *)group withIndex:(NSInteger)index
{
    if(isGroup)
    {
        GroupModel *groupInfo = [[GroupModel alloc] init];
        groupInfo.nodeType = NodeTypeGroup;
        if(group)
        {
            groupInfo.groupName = [NSString stringWithFormat:@"%@%ld",group.groupName,index];
            groupInfo.nodeId = [NSString stringWithFormat:@"%@%ld",group.nodeId,index];
            groupInfo.nodeLevel = group.nodeLevel + 1;
        }
        else
        {
            groupInfo.groupName = [NSString stringWithFormat:@"分组%ld",index];
            groupInfo.nodeId = [NSString stringWithFormat:@"G%ld",index];
            groupInfo.nodeLevel = 0;
        }
        return groupInfo;
    }
    else
    {
        ItemModel *itemInfo = [[ItemModel alloc] init];
        itemInfo.nodeType = NodeTypeItem;
        if(group)
        {
            itemInfo.itemName = [[NSString stringWithFormat:@"%@%ld",group.groupName,index] stringByReplacingOccurrencesOfString:@"分组" withString:@"成员"];
            itemInfo.nodeId = [[NSString stringWithFormat:@"%@%ld",group.nodeId,index] stringByReplacingOccurrencesOfString:@"G" withString:@"I"];
            itemInfo.nodeLevel = group.nodeLevel + 1;
        }
        else
        {
            itemInfo.itemName = [NSString stringWithFormat:@"成员%ld",index];
            itemInfo.nodeId = [NSString stringWithFormat:@"I%ld",index];
            itemInfo.nodeLevel = 0;
        }
        return itemInfo;
    }
}

- (void)addRandomNodesToParent:(JTTree *)parent
{
    BaseModel *praentNode = parent.object;
    
    for(int i = 0; i < 8 ; i++)
    {
        BOOL random = arc4random() % 2;
        if(praentNode.nodeLevel == 5)
        {
            random = NO;
        }
        
        id node = [self creatNode:random withParentNode:(GroupModel *)praentNode withIndex:i];
        
        JTTree *tree = [JTTree treeWithObject:node];
        [parent insertChild:tree atIndex:[parent numberOfChildren]];
        
        if(((BaseModel *)node).nodeType == NodeTypeGroup)
        {
            [self addRandomNodesToParent:tree];
        }
    }
}


@end
