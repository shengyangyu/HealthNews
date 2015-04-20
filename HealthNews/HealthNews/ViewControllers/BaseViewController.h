//
//  BaseViewController.h
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNHeaderFile.h"
#import "CustomerTabBarVC.h"
#import "API_Header.h"
#import "MBProgressHUD.h"
#import "AFInterfaceAPIExcute.h"
#import "BaseResponse.h"

@interface BaseViewController : UIViewController<MBProgressHUDDelegate,AFInterfaceAPIDelegate>
{
    AFInterfaceAPIExcute    *api;           //网络请求
    MBProgressHUD           *HUD;           //加载动画
    
    NSMutableDictionary     *m_Params;      //基类数据字典
}
@property (nonatomic, assign) BOOL isShowTabbar;
@property (nonatomic, assign) BOOL isHideLeftItem;
@property (nonatomic, strong) NSMutableDictionary* m_Params;

/**
 push界面方法
 controllerName:控制器名称
 isNib:是否为xib初始化
 mData:传递值
 */
- (void)pushNewViewController:(NSString *)controllerName
                    isNibPage:(BOOL)isNib
                     withData:(NSMutableDictionary *)mData;
/**
 请求加载动画
 */
- (void)initHUD;
- (void)HUDShow:(NSString*)text;
- (void)HUDShow:(NSString*)text delay:(float)second;
- (void)HUDShow:(NSString*)text delay:(float)second dothing:(BOOL)bDo;
- (void)hudWasHidden:(MBProgressHUD *)hud;
- (void)HUDHidden;
/**
 通用请求方法
 通用请求失败提醒
 */
- (void)apiRequest:(NSString *)_apiUrl
             class:(NSString *)_className
            params:(NSMutableDictionary*)_paras;
- (void)failWithErrorText:(NSString *)text;
/**
 设置页面标题
 */
- (void)titleLabel:(NSString *)labelText;
/**
 温馨提示
 */
- (void)showAlert:(NSString *)message;
/**
 设置导航栏左边按钮
 返回
 返回方法
 */
- (void)addBackNavigationButton;
- (void)goBack;
/**
 设置导航栏右边按钮
 */
- (void)setRightImageButton:(NSString*)imgUrl;


@end
