//
//  UITableViewCell+LLMasonryAutoCellHeight.h
//  LLCellAutoHeightDemo
//
//  Created by Candice on 16/6/23.
//  Copyright © 2016年 Candice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+LLCacheHeight.h"

/*!
 *  @author 刘灵, 16-06-23 10:06:45
 *
 *  获取高度前会回调，需要在此block中配置数据，才能正确获取高度
 */
typedef void(^LLCellBlock)(UITableViewCell *sourceCell);
typedef NSDictionary *(^LLCacheHeight)();

/*!
 *  @author 刘灵, 16-06-23 10:06:06
 *
 *  唯一键，通常是数据模型的id,保证唯一
 */
FOUNDATION_EXTERN NSString *const kLLCacheUniqueKey;

/*!
 *  @author 刘灵, 16-06-23 10:06:27
 *
 *  对于同一个model，如果有不同状态，而且不同状态下高度不一样，那么也需要指定
 */
FOUNDATION_EXTERN NSString *const kLLCacheStateKey;

/*!
 *  @author 刘灵, 16-06-23 10:06:01
 *
 *  用于指定更新某种状态的缓存，比如当评论时，增加了一条评论，此时该状态的高度若已经缓存过，则需要指定来更新缓存
 */
FOUNDATION_EXTERN NSString *const kLLRecalculateForStateKey;

/*!
 *  @author 刘灵, 16-06-23 10:06:23
 *
 *  基于Masonry自动布局实现的自动计算cell的行高扩展
 */

@interface UITableViewCell (LLMasonryAutoCellHeight)

/********************************************************
 *  @author Candice
 *
 *  UI布局必须放在UITableViewCell的初始化方法中：
 *  - initWithStyle:reuseIdentifier:
 * 且必须指定ll_lastViewInCell才能生效
 *******************************************************/

/**
*  @author Candice
*
*  必传设置的属性，也就是在cell中的contentView内最后一个视图，用于计算行高
* 例如，创建了一个按钮button作为在cell中放到最后一个位置，则设置为：self.ll_lastVieInCell = button;即可
* 默认为nil，如果在计算时，值为nil，会crash
*/

@property (nonatomic,strong)UIView *ll_lastViewInCell;

/**
 *  当距离分割线的视图不确定时，可以将可能的所有视图放在这个数组里面，优先级低于上面的属性，也就是当`hyb_lastViewInCell`有值时，`hyb_lastViewsInCell`不起作用
 */
@property (nonatomic,strong)NSArray *ll_lastViewsInCell;

/**
 *  @author Candice
 *
 *  可选设置的属性，默认为0，表示指定的ll_lastViewInCell到cell的bottom的距离
 */
@property(nonatomic,assign)CGFloat ll_bottomOffsetToCell;

/**
 *  通过此方法来计算行高，需要在config中调用配置数据的AP
 *
 *  @param tableView 必传，为哪个tableView缓存行高
 *  @param config 必须要实现，且需要调用配置数据的API
 *
 *  @return 计算的行高
 */
+ (CGFloat)ll_heightForTableView:(UITableView *)tableView config:(LLCellBlock)config;

/**
 *  @author Candice
 *
 *  此API会缓存行高
 *  @param tableView 必传，为哪个tableView缓存行高
 *  @param config 必须要实现，且需要调用配置数据的API
 *  @param cache  返回相关key
 * 
 *  @return 行高
 */
+ (CGFloat)ll_heightForTableView:(UITableView *)tableView config:(LLCellBlock)config cache:(LLCacheHeight)cache;

@end
