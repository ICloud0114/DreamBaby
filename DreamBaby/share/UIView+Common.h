///#begin zh-cn
//
//  Created by ShareSDK.cn on 13-1-14.
//  官网地址:http://www.ShareSDK.cn
//  技术支持邮箱:support@sharesdk.cn
//  官方微信:ShareSDK   （如果发布新版本的话，我们将会第一时间通过微信将版本更新内容推送给您。如果使用过程中有任何问题，也可以通过微信与我们取得联系，我们将会在24小时内给予回复）
//  商务QQ:4006852216
//  Copyright (c) 2013年 ShareSDK.cn. All rights reserved.
//
///#end
///#begin en
//
//  Created by ShareSDK.cn on 13-1-14.
//  website:http://www.ShareSDK.cn
//  Support E-mail:support@sharesdk.cn
//  WeChat ID:ShareSDK   （If publish a new version, we will be push the updates content of version to you. If you have any questions about the ShareSDK, you can get in touch through the WeChat with us, we will respond within 24 hours）
//  Business QQ:4006852216
//  Copyright (c) 2013年 ShareSDK.cn. All rights reserved.
//
///#end

#import <UIKit/UIKit.h>

@interface UIView (Common)

///#begin zh-cn
/**
 *	@brief	获取左上角横坐标
 *
 *	@return	坐标值
 */
///#end
///#begin en
/**
 *	@brief	Get view left.
 *
 *	@return Coordinate value
 */
///#end
- (CGFloat)left;

///#begin zh-cn
/**
 *	@brief	获取左上角纵坐标
 *
 *	@return	坐标值
 */
///#end
///#begin en
/**
 *	@brief	Get view top
 *
 *	@return	Coordinate value
 */
///#end
- (CGFloat)top;

///#begin zh-cn
/**
 *	@brief	获取视图右下角横坐标
 *
 *	@return	坐标值
 */
///#end
///#begin en
/**
 *	@brief	Get view right
 *
 *	@return	Coordinate value
 */
///#end
- (CGFloat)right;

///#begin zh-cn
/**
 *	@brief	获取视图右下角纵坐标
 *
 *	@return	坐标值
 */
///#end
///#begin en
/**
 *	@brief	Get view bottom
 *
 *	@return	Coordinate value
 */
///#end
- (CGFloat)bottom;

///#begin zh-cn
/**
 *	@brief	获取视图宽度
 *
 *	@return	宽度值（像素）
 */
///#end
///#begin en
/**
 *	@brief	Get view width
 *
 *	@return	width（pixel）
 */
///#end
- (CGFloat)width;

///#begin zh-cn
/**
 *	@brief	获取视图高度
 *
 *	@return	高度值（像素）
 */
///#end
///#begin en
/**
 *	@brief	Get view height.
 *
 *	@return	height（pixel）
 */
///#end
- (CGFloat)height;

///#begin zh-cn
/**
 *	@brief	删除所有子对象
 */
///#end
///#begin en
/**
 *	@brief	Remove all sub views.
 */
///#end
- (void)removeAllSubviews;


@end
