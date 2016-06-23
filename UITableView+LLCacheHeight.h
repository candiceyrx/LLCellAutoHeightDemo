//
//  UITableView+LLCacheHeight.h
//  LLCellAutoHeightDemo
//
//  Created by Candice on 16/6/23.
//  Copyright © 2016年 Candice. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  @author 刘灵, 16-06-23 10:06:57
 *
 *  基于Masonry自动布局实现的自动计算cell的行高扩展
 */

@interface UITableView (LLCacheHeight)

/*!
 *  @author 刘灵, 16-06-23 10:06:37
 *
 *  用于缓存cell的行高
 */

@property (nonatomic,strong,readonly)NSMutableDictionary *ll_cacheCellHeightDict;

/*!
 *  @author 刘灵, 16-06-23 10:06:05
 *
 *  用于获取或者添加计算行高的cell，因为理论上只有一个cell用来计算行高，以降低消耗
 */
@property (nonatomic,strong,readonly)NSMutableDictionary *ll_reuseCells;
@end
