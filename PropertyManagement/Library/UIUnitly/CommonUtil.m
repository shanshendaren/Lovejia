#import "CommonUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"


@implementation CommonUtil

//获取当前时间的不同格式字符串
+(NSString *)getCurrentDateString: (int) type {
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    if(type == 1) {
        [dateformat setDateFormat:@"yyyyMMdd"];
    } else if (type == 2) {
        [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    } else if (type == 3) {
        [dateformat setDateFormat:@"yyyyMMddHHmmssSSS"];
    } else if (type == 4) {
        [dateformat setDateFormat:@"yyyy-MM-dd"];
    } else if (type == 5) {
        [dateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    } else if (type == 6) {
        [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    } else if (type == 7) {
        [dateformat setDateFormat:@"MM-dd HH:mm"];
    } else if (type == 8) {
        [dateformat setDateFormat:@"yyyy年M月d日"];
    } else if (type == 9) {
        [dateformat setDateFormat:@"yyyy年M月d日 HH:mm:ss"];
    } else if (type == 10) {
        [dateformat setDateFormat:@"HH:mm"];
    } else if (type == 11) {
        [dateformat setDateFormat:@"HH:mm:ss"];
    } else if (type == 12) {
        [dateformat setDateFormat:@"yyyy-"];
    } else if (type == 13) {
        [dateformat setDateFormat:@"MMddHHmm"];
    } else if (type == 14) {
        [dateformat setDateFormat:@"yyyy年M月"];
    } else if (type == 15) {
        [dateformat setDateFormat:@"yyyy"];
    } else if (type == 16) {
        [dateformat setDateFormat:@"M"];
    } else if (type == 17) {
        [dateformat setDateFormat:@"d"];
    } else if (type == 18) {
        [dateformat setDateFormat:@"yyyyMMddHHmm"];
    } else if (type == 19) {
        [dateformat setDateFormat:@"MM-dd"];
    } else {
        [dateformat setDateFormat:@"yyyy-MM-dd"];
    }
    return [dateformat stringFromDate:[NSDate date]];
}

//获取当前时间的不同格式字符串
+(NSString *) getBeforeDateString: (int) type days:(int)days {
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    if(type == 1) {
        [dateformat setDateFormat:@"yyyyMMdd"];
    } else if (type == 2) {
        [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    } else if (type == 3) {
        [dateformat setDateFormat:@"yyyyMMddHHmmssSSS"];
    } else if (type == 4) {
        [dateformat setDateFormat:@"yyyy-MM-dd"];
    } else if (type == 5) {
        [dateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    } else if (type == 6) {
        [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    } else if (type == 7) {
        [dateformat setDateFormat:@"MM-dd HH:mm"];
    } else if (type == 8) {
        [dateformat setDateFormat:@"yyyy年M月d日"];
    } else if (type == 9) {
        [dateformat setDateFormat:@"yyyy年M月d日 HH:mm:ss"];
    } else if (type == 10) {
        [dateformat setDateFormat:@"HH:mm"];
    } else if (type == 11) {
        [dateformat setDateFormat:@"HH:mm:ss"];
    } else if (type == 12) {
        [dateformat setDateFormat:@"yyyy-"];
    } else if (type == 13) {
        [dateformat setDateFormat:@"MMddHHmm"];
    } else if (type == 14) {
        [dateformat setDateFormat:@"yyyy年M月"];
    } else if (type == 15) {
        [dateformat setDateFormat:@"yyyy"];
    } else if (type == 16) {
        [dateformat setDateFormat:@"M"];
    } else if (type == 17) {
        [dateformat setDateFormat:@"d"];
    } else if (type == 18) {
        [dateformat setDateFormat:@"yyyyMMddHHmm"];
    } else if (type == 19) {
        [dateformat setDateFormat:@"MM-dd"];
    } else {
        [dateformat setDateFormat:@"yyyy-MM-dd"];
    }
    return [dateformat stringFromDate:[NSDate dateWithTimeIntervalSinceNow: -(days*60.0f*60.0f*24.0f)]];
}

+ (NSString*)intervalSinceNow: (NSString*) theDate
{
    NSDateFormatter*date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate  *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    //发表在一小时之内
    if(cha/3600<1) {
        if(cha/60<1) {
            timeString = @"1";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
        }
        
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    //在一小时以上24小以内
    else if(cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    //发表在24以上10000天以内
    else if(cha/86400>1&&cha/864000000<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    //发表时间大于10天
    else
    {
        //        timeString = [NSString stringWithFormat:@"%d-%"]
        NSArray*array = [theDate componentsSeparatedByString:@" "];
        //        return [array objectAtIndex:0];
        timeString = [array objectAtIndex:0];
        timeString = [timeString substringWithRange:NSMakeRange(5, [timeString length]-5)];
    }
    return timeString;
}

//获取5位的数字随机数
+(NSString *) getRandomIntString {
    return [NSString stringWithFormat:@"%05d", arc4random() % 100000];
}

//获取小于20的数字随机数
+(NSString *) getLE20RandomIntString {
    return @"1"; //[NSString stringWithFormat:@"%d", arc4random() % 20 + 1];
}

//获取当前设备（iPhone，iPad）及不同版本
+(NSString *) getCurrentDeviceString {
    return [[UIDevice currentDevice] model];
}

//获取字符串的MD5加密字符串
+ (NSString *) returnMD5Hash:(NSString*)concat {
    const char *concat_str = [concat UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
    
}

//获取前、后子串中间的字符串（包含前后查询子字符串）
+(NSString *)getSubstring:(NSString *)source prefix:(NSString *)p suffix:(NSString *)s {
	NSRange range1 = [source rangeOfString:p];
	NSRange range2 = [source rangeOfString:s options:NSBackwardsSearch];
	
	if(range1.length > 0 && range2.length > 0) {
		return [source substringWithRange:NSMakeRange(range1.location, range2.location - range1.location + [s length])];
	}else {
		return @"";
	}
}

//获取前、后子串中间的字符串（不包含前后查询子字符串）
+(NSString *)getSubstringTrim:(NSString *)source prefix:(NSString *)p suffix:(NSString *)s {
	NSRange range1 = [source rangeOfString:p];
	NSRange range2 = [source rangeOfString:s options:NSBackwardsSearch];
	
	if(range1.length > 0 && range2.length > 0) {
		return [source substringWithRange:NSMakeRange(range1.location + [p length], range2.location - range1.location - [s length] + 1)];
	}else {
		return @"";
	}
}

//查询字符串中是否包含子字符串
+(BOOL) existSubstring:(NSString *)source substring:(NSString *)sub {
    if (source == nil || sub == nil || [source isEqualToString:@""] || [sub isEqualToString:@""]) {
        return NO;
    }
    
    NSRange range = [source rangeOfString:sub];
    if (range.location != NSNotFound) {
        return YES;
    } else {
        return NO;
    }
}

//测试网络连接类型
+ (BOOL) isConnected {  
    // Create zero addy  
    struct sockaddr_in zeroAddress;  
    bzero(&zeroAddress, sizeof(zeroAddress));  
    zeroAddress.sin_len = sizeof(zeroAddress);  
    zeroAddress.sin_family = AF_INET;  
    // Recover reachability flags  
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);  
    SCNetworkReachabilityFlags flags;  
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);  
    CFRelease(defaultRouteReachability);  
    if (!didRetrieveFlags) {  
        NSLog(@"Error. Could not recover network reachability flags");  
        return NO;  
    }  
    BOOL isReachable = flags & kSCNetworkFlagsReachable;  
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;  
    BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;  
    //NSURL *testURL = [NSURL URLWithString:@"http://www.apple.com.cn/"];
    NSURL *testURL = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    //NSURLConnection *testConnection = [[[NSURLConnection alloc] initWithRequest:testRequest delegate:nil] autorelease];  
    NSData *data = [NSURLConnection sendSynchronousRequest:testRequest
										 returningResponse:nil error:nil];
    //return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO; 
    return ((isReachable && !needsConnection) || nonWiFi) ? (data ? YES : NO) : NO;  
}

//是否WIFI
+ (BOOL) isEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G
+ (BOOL) isEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

//获取当前APP的文档根目录
+ (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

//将Unicode字符串转换成UTF8字符串
+ (NSString *)replaceHTMLUnicode:(NSString *)unicodeString {
    NSString *tempStr1 = [unicodeString stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    //NSLog(@"tempStr0:%@", tempStr1);
    tempStr1 = [tempStr1 stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
    //NSLog(@"tempStr1:%@", tempStr1);
    tempStr1 = [tempStr1 stringByReplacingOccurrencesOfString:@"\\n" withString:@"<br>"];
    //NSLog(@"tempStr2:%@", tempStr1);
	tempStr1 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    //NSLog(@"tempStr3:%@", tempStr1);
	tempStr1 = [[@"\"" stringByAppendingString:tempStr1] stringByAppendingString:@"\""];
    //NSLog(@"tempStr4:%@", tempStr1);
	NSData *tempData = [tempStr1 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *error;
	NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription: &error];
	
	NSLog(@"error = %@", error);
	//NSLog(@"Output = %@", returnStr);
	
	return [returnStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
}

//获取字符串的长度（方法一）
+ (int)convertToInt:(NSString*)strtemp {
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<(int)[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

//获取字符串的长度（方法二）
+ (int)getToInt:(NSString*)strtemp {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return [da length];
}

//缩略图像大小
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+ (UIImage *)imageWithScale:(UIImage *)image size:(CGSize)asize {
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    } else {
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        } else {
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        //UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        UIRectFill(CGRectMake(0, 0, rect.size.width, rect.size.height));
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
    
}

+(NSString*)getRandomAlphaString {
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    return (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
}

+(void)alert:(NSString *)title msg:(NSString *)message ok:(NSString *)ok {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:ok otherButtonTitles:nil];
    [alertView show];
}
//聊天中拆分文字图标混排的字符串到数组
+ (void)chatWordIconSeparated:(NSString *)s array:(NSMutableArray *)a {
    //NSLog(@"s is %@",s);
    if(s!=nil){
        
   
    
    int preIndex = 0; //[之前的开始位置
    int beginIndex = 0; //当前的开始标记[位置
    
    NSRange rangeBegin = [s rangeOfString:@"["];
    if (rangeBegin.location != NSNotFound) { //如果查到开始标记，开始执行循环
        
        while (rangeBegin.location != NSNotFound) { //直到查不到开始标记
            beginIndex = rangeBegin.location;
            
            // 开始查询结束标记
            NSRange rangeEnd = [s rangeOfString:@"]" options:nil range:NSMakeRange(rangeBegin.location + 1, s.length - rangeBegin.location - 1)];
            
            // 如果结束标记存在
            if (rangeEnd.location != NSNotFound) {
                // 查找到结束标记后往前查找开始标记，进行开始标记的纠偏（当有开始比较嵌套时）
                NSRange rangeBegin2 = [s rangeOfString:@"[" options:NSBackwardsSearch range:NSMakeRange(rangeBegin.location + 1, rangeEnd.location - rangeBegin.location - 1)];
                //纠正开始标记的位置
                if (rangeBegin2.location != NSNotFound && rangeBegin2.location < rangeEnd.location) {
                    beginIndex = rangeBegin2.location;
                }
                //将标记之前的字符串作为一个对象（如果有，判断依据是上一个结束标记的下一个字符位置）
                if (preIndex < beginIndex) {
                    [a addObject:[s substringWithRange:NSMakeRange(preIndex, beginIndex - preIndex)]];
                }
                //将表情标记加入到数组
                [a addObject:[s substringWithRange:NSMakeRange(beginIndex, rangeEnd.location - beginIndex + 1)]];
                //将结束标记的下一位登记，为下一个循环的图标前字符串的截取做准备
                preIndex = rangeEnd.location + 1;
                
            } else {//如果没有结束标志
                if (a.count == 0) { // 数组中没有数据，则仅加1各对象
                    [a addObject:s];
                } else { //如果之前有对象，则截取后半截
                    [a addObject:[s substringWithRange:NSMakeRange(preIndex, s.length - preIndex)]];
                }
                break;
            }
            //查找下一个开始标志位置
            rangeBegin = [s rangeOfString:@"[" options:nil range:NSMakeRange(rangeEnd.location, s.length - rangeEnd.location)];
            
            if (rangeBegin.location == NSNotFound) {//如果没找到，则直接添加最后一个元素（如果有）
                [a addObject:[s substringWithRange:NSMakeRange(preIndex, s.length - preIndex)]];
                break;
            }
        }
    } else {
        [a addObject:s];
    }
         }
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

+(NSString *)documentPathWith:(NSString *)fileName
{
    
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
}

//计算字数
+ (int)countWord:(NSString*)s
{
    int i,n=[s length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}

/*使用方法
 lblHello.text = @"Hello World!........";
 lblHello.numberOfLines = 2;
 [SSFSColorUtility alignLabelWithTop:lblHello];
 */
+ (void)alignLabelWithTop:(UILabel *)label {
    CGSize maxSize = CGSizeMake(label.frame.size.width, 999);
    label.adjustsFontSizeToFitWidth = NO;
    
    //get actual height
    CGSize actualSize = [label.text sizeWithFont:label.font
                               constrainedToSize:maxSize
                                   lineBreakMode:label.lineBreakMode];
    CGRect rect = label.frame;
    rect.size.height = actualSize.height;
    label.frame = rect;
}

+ (NSString *)filterNullString:(NSString *)str {
    if (!str) {
        return @"";
    }else if ([str isEqualToString:@"null"] || [str isEqualToString:@"\"null\""]) {
        return @"";
    }else {
        return str;
    }
}


+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
