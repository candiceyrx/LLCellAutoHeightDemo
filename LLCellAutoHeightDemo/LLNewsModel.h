//
//  LLNewsModel.h
//  LLCellAutoHeightDemo
//
//  Created by Candice on 16/6/23.
//  Copyright © 2016年 Candice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLNewsModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) int uid;
@property (nonatomic, assign) BOOL isExpand;
@end
