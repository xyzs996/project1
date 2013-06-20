//
//  MyDetailViewController.h
//  Conference
//
//  Created by wu xiaofang on 13-6-14.
//  Copyright (c) 2013年 wu xiaofang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PosBaseViewController.h"
typedef enum{
    LoadMyConference = 100,       //我的会议
    LoadPublicConference,   //公共会议
    LoadCreateConference,   //创建会议
    LoadMyTask              //我的任务
}LoadType;


@interface MyDetailViewController : PosBaseViewController<UISplitViewControllerDelegate>

- (void)loadDataSource:(LoadType)loadtype;
@end
