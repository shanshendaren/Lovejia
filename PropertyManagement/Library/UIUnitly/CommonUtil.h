#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>  
#import <SystemConfiguration/SystemConfiguration.h>  
#import <netinet/in.h>  
#import <arpa/inet.h>  
#import <netdb.h> 
//#import "SpbConstant.h"


@interface CommonUtil : NSObject {
}

//获取当前时间的不同格式字符串
+(NSString *) getCurrentDateString: (int) type;

//获取当前时间的不同格式字符串
+(NSString *) getBeforeDateString: (int) type days:(int)days;

//获取5位的数字随机数
+(NSString *) getRandomIntString;

//获取小于20的数字随机数
+(NSString *) getLE20RandomIntString;

//获取当前设备（iPhone，iPad）及不同版本
+(NSString *) getCurrentDeviceString;

//获取字符串的MD5加密字符串
+(NSString *) returnMD5Hash:(NSString*)concat;

//获取前、后子串中间的字符串（包含前后查询子字符串）
+(NSString *) getSubstring:(NSString *)source prefix:(NSString *)p suffix:(NSString *)s;

//获取前、后子串中间的字符串（不包含前后查询子字符串）
+(NSString *) getSubstringTrim:(NSString *)source prefix:(NSString *)p suffix:(NSString *)s;

//查询字符串中是否包含子字符串
+(BOOL) existSubstring:(NSString *)source substring:(NSString *)sub;

//测试网络连接类型
+ (BOOL) isConnected; //是否连接
+ (BOOL) isEnableWIFI; //是否WIFI
+ (BOOL) isEnable3G; //是否3G

//获取当前APP的文档根目录
+ (NSString *)applicationDocumentsDirectory;

//将Unicode字符串转换成UTF8字符串
+ (NSString *)replaceHTMLUnicode:(NSString *)unicodeString;

//获取字符串的长度
+ (int)convertToInt:(NSString*)strtemp;
+ (int)getToInt:(NSString*)strtemp;

//缩小图片到指定大小
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
//缩小图片到指定比例
+ (UIImage *)imageWithScale:(UIImage *)image size:(CGSize)asize;

//获取唯一的UUID
+(NSString*)getRandomAlphaString;

//提示框
+(void)alert:(NSString *)title msg:(NSString *)message ok:(NSString *)ok;
//查询时间间隔天数
+ (NSString*)intervalSinceNow: (NSString*) theDate;

//聊天中拆分文字图标混排的字符串到数组
+ (void)chatWordIconSeparated:(NSString *)s array:(NSMutableArray *)a;

/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile;

+(NSString *)documentPathWith:(NSString *)fileName;

//计算字数
+ (int)countWord:(NSString*)s;
/*使用方法
 lblHello.text = @"Hello World!........";
 lblHello.numberOfLines = 2;
 [SSFSColorUtility alignLabelWithTop:lblHello];
 */
+ (void)alignLabelWithTop:(UILabel *)label;

//过滤null字符串
+ (NSString *)filterNullString:(NSString *)str;

//将照片旋转到正确的方向，并且返回的imageOrientaion为0
+ (UIImage *)fixOrientation:(UIImage *)aImage;
@end
