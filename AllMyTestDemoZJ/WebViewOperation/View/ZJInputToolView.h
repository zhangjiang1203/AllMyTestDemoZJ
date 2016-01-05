//
//  ZJInputToolView.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/5.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendMessageAction)(NSString *message);

@interface ZJInputToolView : UIView
//添加appTOJS的交互

-(void)sendMessageToJavaScript:(SendMessageAction)messageAction;
@end
