//
//  TreeViewController.h
//  OutlineView
//
//  Created by xhw on 16/5/9.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TreeViewController;

@protocol TreeViewControllerDelegate <NSObject>

@optional
- (void)treeViewController:(TreeViewController *)vc didChangeSelected:(NSString *)selectedId;

@end

@interface TreeViewController : UIViewController

@property (nonatomic, assign) id<TreeViewControllerDelegate> delegate;


- (id)initWithData:(NSArray *)array;

- (void)reloadDisplayArray;

@end
