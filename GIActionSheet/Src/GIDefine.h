//
//  GIDefine.h
//  GIActionSheet
//
//  Created by 高云杰 on 16/10/1.
//  Copyright © 2016年 gyj. All rights reserved.
//

#ifndef GIDefine_h
#define GIDefine_h

/// 显示样式
typedef NS_ENUM(NSInteger, GIActionSheetStyle)  {
    GIActionSheetStyleList = 1, // 列表
    GIActionSheetStyleGrid // 九宫格样式
};

/// List - 行高
#define LIST_CELL_HEIGHT                (50.f)

/// Gird - Item高
#define GRID_CELL_HEIGHT                (100.f)
/// Gird - Item宽
#define GRID_CELL_WIDTH                 (80.f)

/// Gird - 内边距定义
#define GRID_CONTENT_PADDING            UIEdgeInsetsMake(10, 16, 0, 16)


/// 分割线颜色
#define DEFAULT_SEPRATE_COLOR      [UIColor colorWithWhite:0 alpha:0.2]

/// UI线程执行
#define RUN_ON_MAIN_THREAD(block)  if ([NSThread isMainThread]) { \
                                       block(); \
                                   } else { \
                                       dispatch_async(dispatch_get_main_queue(), block);\
                                   }

#endif /* GIDefine_h */
