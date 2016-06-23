//
//  UITableView+LLCacheHeight.m
//  LLCellAutoHeightDemo
//
//  Created by Candice on 16/6/23.
//  Copyright © 2016年 Candice. All rights reserved.
//

#import "UITableView+LLCacheHeight.h"
#import <objc/runtime.h>

static const void * ll_tableView_cacheCellHeightKey = @"__ll_tableView_cacheCellHeightKey";
static const void * ll_tavleView_reuse_cells_key = @"__ll_tableView_reuse_cells_key";

@implementation UITableView (LLCacheHeight)

- (NSMutableDictionary *)ll_cacheCellHeightDict{
    NSMutableDictionary *dict = objc_getAssociatedObject(self, ll_tableView_cacheCellHeightKey);
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc]init];
        objc_setAssociatedObject(self,
                                 ll_tableView_cacheCellHeightKey,
                                 dict,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}

- (NSMutableDictionary *)ll_reuseCells{
    NSMutableDictionary *cells = objc_getAssociatedObject(self, ll_tavleView_reuse_cells_key);
    if (cells == nil) {
        cells = [[NSMutableDictionary alloc]init];
        objc_setAssociatedObject(self,
                                 ll_tavleView_reuse_cells_key,
                                 cells,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cells;
}

@end
