# GIActionSheet
An ActionSheet component in iOS platform. Provide two styles (list / grid) for sheet's content region.
![grid style](/Docs/demo_grid_style.png) 
![list style](/Docs/demo_list_style.png) 

# Adding GIActionSheet to your project
1. Copy /src foler to your project.
2. In the source files where you need to use the library, import the header file:
#import <GIActionSheet.h>
3. Create and show an ActionSheet like this:
``` objective-c
// list style
GIActionSheet *sheet = [[GIActionSheet alloc] initWithStyle:GIActionSheetStyleList];
    sheet.title = @"ActionSheet - List mode";
    sheet.cancelable = YES;
    sheet.cancelTitle = @"Choose Later";
    sheet.dismissWhenTapOutside = YES;
    sheet.actions = @[[GIAction actionWithTitle:@"Option 1. Dismiss when clicked." icon:nil/*[UIImage imageNamed:@"icon_share_platform_qq_friend"]*/ action:^(BOOL * _Nonnull dismiss) {
                      }],
                      [GIAction actionWithTitle:@"Option 2. Does not dismiss when clicked." action:^(BOOL * _Nonnull dismiss) {
                              *dismiss = NO;
                      }]];
    [sheet show];

// gird style
GIActionSheet *sheet = [[GIActionSheet alloc] initWithStyle:GIActionSheetStyleGrid];
    sheet.title = @"ActionSheet - Grid mode";
    sheet.cancelable = YES;
    sheet.cancelTitle = @"Choose Later";
    sheet.dismissWhenTapOutside = YES;
    sheet.actions = @[[GIAction actionWithTitle:@"Opt 1" icon:[UIImage imageNamed:@"icon_share_platform_qq_friend"] action:^(BOOL * _Nonnull dismiss) {
    }],
                      [GIAction actionWithTitle:@"Opt 2" icon:[UIImage imageNamed:@"icon_share_platform_qq_zone"] action:^(BOOL * _Nonnull dismiss) {
                      }],
                      [GIAction actionWithTitle:@"Opt 3" icon:[UIImage imageNamed:@"icon_share_platform_wechat_friend"] action:^(BOOL * _Nonnull dismiss) {
                      }],
                      [GIAction actionWithTitle:@"Opt 4" icon:[UIImage imageNamed:@"icon_share_platform_wechat_timeline"] action:^(BOOL * _Nonnull dismiss) {
                      }],
                      [GIAction actionWithTitle:@"Opt 5" icon:[UIImage imageNamed:@"icon_share_platform_weibo"] action:^(BOOL * _Nonnull dismiss) {
                      }]];
    [sheet show];
``` 

# More
Using these property in GIAction to define ui style.
``` objective-c
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, strong, nullable) UIColor *normalTitleColor;
@property (nonatomic, strong, nullable) UIColor *disableTitleColor;
@property (nonatomic, strong, nullable) UIFont *titleFont;
```

----
Hide cancel btn if **GIActionSheet.cancelable** is set to NO.
You can also change actions when ActionSheet is already shown, using statements below:
``` objective-c
- (BOOL)addAction:(GIAction * _Nonnull)action;
- (BOOL)addAction:(GIAction * _Nonnull)action atIndex:(NSUInteger)index;
- (BOOL)setAction:(GIAction * _Nonnull)action atIndex:(NSUInteger)index;
- (GIAction * _Nonnull)removeActionAtIndex:(NSUInteger)index;
- (NSUInteger)removeAction:(GIAction * _Nonnull)action;
```
Other features please see GIActionSheet.h and GIAction.h .

