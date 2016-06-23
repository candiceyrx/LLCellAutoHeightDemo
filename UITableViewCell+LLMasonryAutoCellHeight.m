//
//  UITableViewCell+LLMasonryAutoCellHeight.m
//  LLCellAutoHeightDemo
//
//  Created by Candice on 16/6/23.
//  Copyright © 2016年 Candice. All rights reserved.
//

#import "UITableViewCell+LLMasonryAutoCellHeight.h"
#import <objc/runtime.h>
#import "UITableView+LLCacheHeight.h"

NSString *const kLLCacheUniqueKey = @"kLLCacheUniqueKey";
NSString *const kLLCacheStateKey = @"kLLCacheStateKey";
NSString *const kLLRecalculateForStateKey = @"kLLRecalculateForStateKey";
NSString *const kLLCacheForTableViewKey = @"kLLCacheForTableViewKey";

const void *s_ll_lastViewInCellKey = "ll_lastViewInCellKey";
const void *s_ll_bottomOffsetToCellKey = "ll_bottomOffsetToCellKey";

@implementation UITableViewCell (LLMasonryAutoCellHeight)

#pragma mark - Public

+(CGFloat)ll_heightForTableView:(UITableView *)tableView config:(LLCellBlock)config{
    UITableViewCell *cell = [tableView.ll_reuseCells objectForKey:[[self class] description]];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [tableView.ll_reuseCells setObject:cell forKey:[[self class]description]];
    }
    if (config) {
        config(cell);
    }
    
    return [cell private_ll_heightForTableView:tableView ];
                             
}

+ (CGFloat)ll_heightForTableView:(UITableView *)tableView config:(LLCellBlock)config cache:(LLCacheHeight)cache{
    if (cache) {
        NSDictionary *cacheKeys = cache();
        NSString *key = cacheKeys[kLLCacheUniqueKey];
        NSString *stateKey = cacheKeys[kLLCacheStateKey];
        NSString *shouldUpdate = cacheKeys[kLLRecalculateForStateKey];
        
        NSMutableDictionary *stateDict = tableView.ll_cacheCellHeightDict[key];
        NSString *cacheHeight = stateDict[stateKey];
        
        if (tableView == nil
            || tableView.ll_cacheCellHeightDict.count == 0
            || shouldUpdate.boolValue
            || cacheHeight == nil) {
            CGFloat height = [self ll_heightForTableView:tableView config:config];
            
            if (stateDict == nil) {
                stateDict = [[NSMutableDictionary alloc]init];
                tableView.ll_cacheCellHeightDict[key] = stateDict;
            }
            
            [stateDict setObject:[NSString stringWithFormat:@"%lf",height] forKey:stateKey];
            
            return height;
        } else if (tableView.ll_cacheCellHeightDict.count != 0
                   && cacheHeight != nil
                   && cacheHeight.integerValue != 0){
            return cacheHeight.floatValue;
        }
    }
    
    return [self ll_heightForTableView:tableView config:config];
}

- (void)setLl_lastViewInCell:(UIView *)ll_lastViewInCell{
    objc_setAssociatedObject(self,
                             s_ll_lastViewInCellKey,
                             ll_lastViewInCell,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)ll_lastViewInCell{
    return objc_getAssociatedObject(self, s_ll_lastViewInCellKey);
}

- (void)setLl_lastViewsInCell:(NSArray *)ll_lastViewsInCell{

    objc_setAssociatedObject(self,
                             @selector(ll_lastViewsInCell),
                             ll_lastViewsInCell,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)ll_lastViewsInCell{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLl_bottomOffsetToCell:(CGFloat)ll_bottomOffsetToCell{
    objc_setAssociatedObject(self,
                             s_ll_bottomOffsetToCellKey,
                             @(ll_bottomOffsetToCell),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)ll_bottomOffsetToCell{
    NSNumber *valueObject = objc_getAssociatedObject(self, s_ll_bottomOffsetToCellKey);
    if ([valueObject respondsToSelector:@selector(floatValue)]) {
        return valueObject.floatValue;
    }
    
    return 0.0;
}
#pragma mark - Private

-(CGFloat)private_ll_heightForTableView:(UITableView *)tableView{
    NSAssert(self.ll_lastViewInCell != nil
             || self.ll_lastViewsInCell.count != 0,
             @"您未指定cell排列中最后的视图对象，无法计算cell的高度");
    [self layoutIfNeeded];
    
    CGFloat rowHeight = 0.0;
    
    if (self.ll_lastViewInCell) {
        rowHeight = self.ll_lastViewInCell.frame.size.height + self.ll_lastViewInCell.frame.origin.y;
    } else {
        for (UIView *view in self.ll_lastViewsInCell) {
            if (rowHeight < CGRectGetMaxY(view.frame)) {
                rowHeight = CGRectGetMaxY(view.frame);
            }
        }
    }
    
    rowHeight += self.ll_bottomOffsetToCell;
    
    return rowHeight;
}

@end
