//
//  HNHeaderFile.h
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#ifndef HealthNews_HNHeaderFile_h
#define HealthNews_HNHeaderFile_h

//设备屏幕大小
#define __MainScreenFrame [[UIScreen mainScreen] bounds]
#define __MainScreen_Width __MainScreenFrame.size.width
//设备屏幕高 20,表示状态栏高度.如3.5inch 的高,得到的__MainScreenFrame.size.height是480,而去掉电量那条状态栏,我们真正用到的是460;
#define __MainScreen_Height (__MainScreenFrame.size.height-20)
//试图内容高度 1
#define __viewContent_hight1 (__MainScreen_Height-44)//-导航条
//试图内容高度 2
#define __viewContent_hight2 (__MainScreen_Height-49)//－tabbar
//试图内容高度 3
#define __viewContent_hight3 (__MainScreen_Height-49-44)//－tabbar -导航条
#define kShowTitleAfterDelay 2
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)



#endif
