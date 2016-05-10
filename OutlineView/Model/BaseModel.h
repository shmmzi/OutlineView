//
//  BaseModel.h
//  OutlineView
//
//  Created by xhw on 16/5/9.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SelectStatus) {
    SelectStatusNone = 0,//未选
    SelectStatusAll,//全选
    SelectStatusOther,//半选
};

typedef NS_ENUM(NSInteger, NodeType) {
    NodeTypeGroup = 0,
    NodeTypeItem,
};


@interface BaseModel : NSObject

@property (nonatomic) int nodeLevel; //节点所处层次
@property (nonatomic) BOOL isExpanded;//节点是否展开
@property (nonatomic) SelectStatus selectStatus;//选中状态

@property (nonatomic) NodeType nodeType;

@property (nonatomic,strong) NSString *nodeId;

@end
