#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import "RNState.h"

@interface RNState () <CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation RNState

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

#pragma mark - Initialization

- (instancetype)init {
  if (self = [super init]) {
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
  }
  
  return self;
}

#pragma mark - React Native Export methods

RCT_REMAP_METHOD(isBluetoothEnabled,
                 ibe_resolver:(RCTPromiseResolveBlock)resolve
                 ibe_rejecter:(RCTPromiseRejectBlock)reject)
{
  @try {
    NSString* state = [self getBluetoothState];
    NSArray *events;
    if([state  isEqual: @"powered_on"]){
      events = @YES;
    }else{
      events = @NO;
    }
    resolve(events);
  }
  @catch (NSException *exception) {
    reject(@"no_events", @"There were no events", exception);
  }
}

RCT_REMAP_METHOD(isLocationEnabled,
                 ile_resolver:(RCTPromiseResolveBlock)resolve
                 ile_rejecter:(RCTPromiseRejectBlock)reject)
{
  @try {
    resolve([NSNumber numberWithBool:[CLLocationManager locationServicesEnabled]]);
  }
  @catch (NSException *exception) {
    reject(@"no_events", @"There were no events", exception);
  }
}

RCT_REMAP_METHOD(isLocationAuthorized,
                 ila_resolver:(RCTPromiseResolveBlock)resolve
                 ila_rejecter:(RCTPromiseRejectBlock)reject)
{
  @try {
    resolve([NSNumber numberWithBool:[self isLocationAuthorized]]);
  }
  @catch (NSException *exception) {
    reject(@"no_events", @"There were no events", exception);
  }
}

#pragma mark - Private methods

- (NSString*)getBluetoothState{
  NSString* state;
  NSString* description;
  
  switch(self.centralManager.state)
  {
      
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    case CBManagerStateResetting:
#else
    case CBCentralManagerStateResetting:
#endif
      state = @"resetting";
      description =@"The connection with the system service was momentarily lost, update imminent.";
      break;
      
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    case CBManagerStateUnsupported:
#else
    case CBCentralManagerStateUnsupported:
#endif
      state = @"unsupported";
      description = @"The platform doesn't support Bluetooth Low Energy.";
      break;
      
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    case CBManagerStateUnauthorized:
#else
    case CBCentralManagerStateUnauthorized:
#endif
      state = @"unauthorized";
      description = @"The app is not authorized to use Bluetooth Low Energy.";
      break;
      
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    case CBManagerStatePoweredOff:
#else
    case CBCentralManagerStatePoweredOff:
#endif
      state = @"powered_off";
      description = @"Bluetooth is currently powered off.";
      break;
      
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    case CBManagerStatePoweredOn:
#else
    case CBCentralManagerStatePoweredOn:
#endif
      state = @"powered_on";
      description = @"Bluetooth is currently powered on and available to use.";
      break;
    default:
      state = @"unknown";
      description = @"State unknown, update imminent.";
      break;
  }
  NSLog(@"Bluetooth state changed: %@",description);
  
  
  return state;
}

- (NSString*) getLocationAuthorizationStatusAsString: (CLAuthorizationStatus)authStatus
{
  NSString* status;
  if(authStatus == kCLAuthorizationStatusDenied || authStatus == kCLAuthorizationStatusRestricted){
    status = @"denied";
  }else if(authStatus == kCLAuthorizationStatusNotDetermined){
    status = @"not_determined";
  }else if(authStatus == kCLAuthorizationStatusAuthorizedAlways){
    status = @"authorized";
  }else if(authStatus == kCLAuthorizationStatusAuthorizedWhenInUse){
    status = @"authorized_when_in_use";
  }
  return status;
}

- (BOOL) isLocationAuthorized
{
  CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
  NSString* status = [self getLocationAuthorizationStatusAsString:authStatus];
  if([status  isEqual: @"authorized"] || [status  isEqual: @"authorized_when_in_use"]) {
    return true;
  } else {
    return false;
  }
}

#pragma mark - Bluetooth Delegate

- (void) centralManagerDidUpdateState:(CBCentralManager *)central {
  
}

@end
