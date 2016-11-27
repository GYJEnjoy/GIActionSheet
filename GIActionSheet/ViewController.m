//
//  ViewController.m
//  GIActionSheet
//
//  Created by 高云杰 on 16/9/29.
//  Copyright © 2016年 gyj. All rights reserved.
//

#import "ViewController.h"
#import "GIActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (IBAction)showActionSheetAsList:(id)sender {
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
//    [GIActionSheet showAsListWithtitle:@"ActionSheet - List mode"
//                          actionTitles:@[@"Option 1.",@"Option 2.",@"Option 3.",@"Option 4."]
//                            cancelable:NO
//                               onClick:^(NSUInteger index) {
//        
//    }];
}

- (IBAction)showActionSheetAsGrid:(id)sender {
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
    
//    [GIActionSheet showAsGridWithtitle:@"ActionSheet - Grid mode"
//                          actionTitles:@[@"Opt 1",@"Opt 2",@"Opt 3",@"Opt 4"]
//                           actionIcons:@[[UIImage imageNamed:@"icon_share_platform_qq_friend"],[UIImage imageNamed:@"icon_share_platform_qq_zone"],[UIImage imageNamed:@"icon_share_platform_wechat_friend"],[UIImage imageNamed:@"icon_share_platform_wechat_timeline"]]
//                            cancelable:YES
//                               onClick:^(NSUInteger index) {
//        
//    }];
}


@end
