//
//  GIActionSheetManager.h
//  GIActionSheet
//
//  Created by 高云杰 on 16/10/1.
//  Copyright © 2016年 gyj. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GIActionSheet;

@interface GIActionSheetManager : NSObject
/// 单例
+ (nonnull instancetype)sharedInstance;

#pragma mark - 试图堆栈控制
/**
 * 加入队列。如果当前已经有组件处于显示状态，则压入队列，等待显示。
 * @param actionSheet 需要显示的actionSheet
 */
- (void)pushActionSheet:(nonnull GIActionSheet *)actionSheet;

/**
 * 从队列去除。
 * @param actionSheet 需要显示的actionSheet
 */
- (void)popActionSheet:(nonnull GIActionSheet *)actionSheet;
@end
