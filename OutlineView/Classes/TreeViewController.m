//
//  TreeViewController.m
//  OutlineView
//
//  Created by xhw on 16/5/9.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "TreeViewController.h"

#import "JTTree.h"
#import "GroupTableViewCell.h"
#import "ItemTableViewCell.h"

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

@interface TreeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *nodeList;
@property (strong,nonatomic ) NSArray     *displayArray;//保存要显示在界面上的数据的数组

@end

@implementation TreeViewController

- (id)initWithData:(NSArray *)array
{
    self = [super init];
    if(self)
    {
        self.nodeList = array;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"树形界面";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self reloadDisplayArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _displayArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTTree *tree = [_displayArray objectAtIndex:indexPath.row];
    BaseModel *node = tree.object;
    
    if(node.nodeType == NodeTypeGroup)
    {
        GroupTableViewCell *cell = [GroupTableViewCell cellWithTableView:tableView];
        [cell setData:(GroupModel *)node];
        return cell;
    }
    else
    {
        ItemTableViewCell *cell = [ItemTableViewCell cellWithTableView:tableView];
        [cell setData:(ItemModel *)node];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JTTree *tree = [_displayArray objectAtIndex:indexPath.row];
    BaseModel *node = tree.object;
    if(node.selectStatus == SelectStatusAll)
    {
        node.selectStatus = SelectStatusNone;
    }
    else
    {
        node.selectStatus = SelectStatusAll;
    }
    
    //刷新组的子节点
    if(node.nodeType == NodeTypeGroup)
    {
        [self refreshAllChildrenAtParent:tree withSelectStatus:node.selectStatus];
    }
    
    //刷新当前节点所有父节点
    [self refreshAllParentSelectStatus:tree.parent];
    
    [self.tableView reloadData];
    
    if([self.delegate respondsToSelector:@selector(treeViewController:didChangeSelected:)])
    {
        NSString *string = [self getSelectedParamters:self.nodeList];
        [self.delegate treeViewController:self didChangeSelected:string];
    }
}


#pragma mark - 重组显示数据

- (void)reloadDisplayArray
{
    NSMutableArray *tmpList = [[NSMutableArray alloc]init];
    
    for (JTTree *tree in self.nodeList)
    {
        BaseModel *node = tree.object;
        
        if(node.nodeType == NodeTypeGroup)
        {
            if(node.isExpanded == YES)
            {
                [self addTree:tree toArray:tmpList];
            }
            else
            {
                [tmpList addObject:tree];
            }
        }
        else
        {
            [tmpList addObject:tree];
        }
    }
    
    _displayArray = [NSArray arrayWithArray:tmpList];
    
    [self.tableView reloadData];
}

- (void)addTree:(JTTree *)tree toArray:(NSMutableArray *)tmpList
{
    [tmpList addObject:tree];
    
    BaseModel *node = tree.object;
    
    if([tree numberOfChildren] > 0 && node.isExpanded == YES)
    {
        [tree enumerateDescendantsWithOptions:JTTreeTraversalChildrenOnly usingBlock:^(JTTree *descendant, BOOL *stop) {
            [self addTree:descendant toArray:tmpList];
        }];
    }
}

#pragma mark - 选中数据发生变化
//子节点发生变化，重新计算所有父节点的状态，递归
- (void)refreshAllParentSelectStatus:(JTTree *)tree
{
    if(tree)
    {
        BaseModel *node = tree.object;
        node.selectStatus = [self getTreeStatus:tree];
    }
    else
    {
        return;
    }
    
    if(tree.parent)
    {
        [self refreshAllParentSelectStatus:tree.parent];
    }
}

//根据所有子节点的状态来计算父节点状态
- (SelectStatus)getTreeStatus:(JTTree *)tree
{
    __block BOOL hasSelected = NO;
    __block BOOL hasUnselected = NO;
    [tree enumerateDescendantsWithOptions:JTTreeTraversalBreadthFirst usingBlock:^(JTTree *descendant, BOOL *stop) {
        if(descendant != tree)
        {
            BaseModel *descendantNode = descendant.object;
            if(descendantNode.selectStatus == SelectStatusOther)
            {
                hasSelected = YES;
                hasUnselected = YES;
            }
            else if(descendantNode.selectStatus == SelectStatusAll)
            {
                hasSelected = YES;
            }
            else
            {
                hasUnselected = YES;
            }
            
            if(hasUnselected == YES && hasSelected == YES)
            {
                *stop = YES;
            }
        }
    }];
    
    if(hasSelected == YES && hasUnselected == YES)
    {
        return SelectStatusOther;
    }
    else if(hasUnselected == YES)
    {
        return SelectStatusNone;
    }
    else
    {
        return SelectStatusAll;
    }
}

//组操作后，将组的所有子节点同步
- (void)refreshAllChildrenAtParent:(JTTree *)tree withSelectStatus:(SelectStatus)selectStatus
{
    [tree enumerateDescendantsWithOptions:JTTreeTraversalBreadthFirst usingBlock:^(JTTree *descendant, BOOL *stop) {
        BaseModel *descendantNode = descendant.object;
        descendantNode.selectStatus = selectStatus;
    }];
}

#pragma mark - 获取结果
//根据选中状态拼接出请求参数 @"i1,i2..."
- (NSString *)getSelectedParamters:(NSArray *)memberList
{
    NSMutableString *idList = [NSMutableString string];
    
    for (JTTree *tree in memberList)
    {
        BaseModel *node = tree.object;
        
        if(node.nodeType == NodeTypeGroup)
        {
            if(node.selectStatus == SelectStatusAll)
            {
                [idList appendFormat:@"%@,",node.nodeId];
            }
            else if(node.selectStatus == SelectStatusOther)
            {
                [self appendId:idList withTree:tree];
            }
        }
        else
        {
            if(node.selectStatus == SelectStatusAll)
            {
                [idList appendFormat:@"%@,",node.nodeId];
            }
        }
    }
    
    if(idList.length > 0)
    {
        [idList deleteCharactersInRange:NSMakeRange(idList.length - 1, 1)];
    }
    
    return idList;
}

//递归拼接，如果分组为半选状态
- (void)appendId:(NSMutableString *)idList withTree:(JTTree *)tree
{
    [tree enumerateDescendantsWithOptions:JTTreeTraversalChildrenOnly usingBlock:^(JTTree *descendant, BOOL *stop) {
        BaseModel *descendantNode = descendant.object;
        if(descendantNode.nodeType == NodeTypeGroup)
        {
            if(descendantNode.selectStatus == SelectStatusAll)
            {
                [idList appendFormat:@"%@,",descendantNode.nodeId];
            }
            else if(descendantNode.selectStatus == SelectStatusOther)
            {
                [self appendId:idList withTree:descendant];
            }
        }
        else
        {
            if(descendantNode.selectStatus == SelectStatusAll)
            {
                [idList appendFormat:@"%@,",descendantNode.nodeId];
            }
        }
    }];
}


@end
