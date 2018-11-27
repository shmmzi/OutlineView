//
//  ItemModel.h
//  OutlineView
//
//  Created by xhw on 16/5/9.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "BaseModel.h"

//item数据，可按照需求自己扩展字段
@interface ItemModel : BaseModel

@property (nonatomic,strong) NSString *itemName;

@end
