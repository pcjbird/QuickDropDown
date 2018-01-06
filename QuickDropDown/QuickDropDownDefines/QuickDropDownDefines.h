//
//  QuickDropDownDefines.h
//  QuickDropDown
//
//  Created by pcjbird on 2018/1/6.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#ifndef QuickDropDownDefines_h
#define QuickDropDownDefines_h

#ifdef DEBUG
#   define SDK_LOG(fmt, ...) NSLog((@"[🦉QuickDropDown] %s (line %d) " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define SDK_LOG(fmt, ...) (nil)
#endif

#endif /* QuickDropDownDefines_h */
