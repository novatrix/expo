//
//  ABI18_0_0AIRGoogleMap.m
//  AirMaps
//
//  Created by Gil Birman on 9/1/16.
//

#import "ABI18_0_0AIRGoogleMap.h"
#import "ABI18_0_0AIRGoogleMapMarker.h"
#import "ABI18_0_0AIRGoogleMapPolygon.h"
#import "ABI18_0_0AIRGoogleMapPolyline.h"
#import "ABI18_0_0AIRGoogleMapCircle.h"
#import "ABI18_0_0AIRGoogleMapUrlTile.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import <ReactABI18_0_0/UIView+ReactABI18_0_0.h>
#import "ABI18_0_0RCTConvert+AirMap.h"

id regionAsJSON(MKCoordinateRegion region) {
  return @{
           @"latitude": [NSNumber numberWithDouble:region.center.latitude],
           @"longitude": [NSNumber numberWithDouble:region.center.longitude],
           @"latitudeDelta": [NSNumber numberWithDouble:region.span.latitudeDelta],
           @"longitudeDelta": [NSNumber numberWithDouble:region.span.longitudeDelta],
           };
}

@interface ABI18_0_0AIRGoogleMap ()

- (id)eventFromCoordinate:(CLLocationCoordinate2D)coordinate;

@end

@implementation ABI18_0_0AIRGoogleMap
{
  NSMutableArray<UIView *> *_ReactABI18_0_0Subviews;
  BOOL _initialRegionSet;
}

- (instancetype)init
{
  if ((self = [super init])) {
    _ReactABI18_0_0Subviews = [NSMutableArray new];
    _markers = [NSMutableArray array];
    _polygons = [NSMutableArray array];
    _polylines = [NSMutableArray array];
    _circles = [NSMutableArray array];
    _tiles = [NSMutableArray array];
    _initialRegionSet = false;
  }
  return self;
}
- (id)eventFromCoordinate:(CLLocationCoordinate2D)coordinate {

  CGPoint touchPoint = [self.projection pointForCoordinate:coordinate];

  return @{
           @"coordinate": @{
               @"latitude": @(coordinate.latitude),
               @"longitude": @(coordinate.longitude),
               },
           @"position": @{
               @"x": @(touchPoint.x),
               @"y": @(touchPoint.y),
               },
           };
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)insertReactABI18_0_0Subview:(id<ABI18_0_0RCTComponent>)subview atIndex:(NSInteger)atIndex {
  // Our desired API is to pass up markers/overlays as children to the mapview component.
  // This is where we intercept them and do the appropriate underlying mapview action.
  if ([subview isKindOfClass:[ABI18_0_0AIRGoogleMapMarker class]]) {
    ABI18_0_0AIRGoogleMapMarker *marker = (ABI18_0_0AIRGoogleMapMarker*)subview;
    marker.realMarker.map = self;
    [self.markers addObject:marker];
  } else if ([subview isKindOfClass:[ABI18_0_0AIRGoogleMapPolygon class]]) {
    ABI18_0_0AIRGoogleMapPolygon *polygon = (ABI18_0_0AIRGoogleMapPolygon*)subview;
    polygon.polygon.map = self;
    [self.polygons addObject:polygon];
  } else if ([subview isKindOfClass:[ABI18_0_0AIRGoogleMapPolyline class]]) {
    ABI18_0_0AIRGoogleMapPolyline *polyline = (ABI18_0_0AIRGoogleMapPolyline*)subview;
    polyline.polyline.map = self;
    [self.polylines addObject:polyline];
  } else if ([subview isKindOfClass:[ABI18_0_0AIRGoogleMapCircle class]]) {
    ABI18_0_0AIRGoogleMapCircle *circle = (ABI18_0_0AIRGoogleMapCircle*)subview;
    circle.circle.map = self;
    [self.circles addObject:circle];
  } else if ([subview isKindOfClass:[ABI18_0_0AIRGoogleMapUrlTile class]]) {
    ABI18_0_0AIRGoogleMapUrlTile *tile = (ABI18_0_0AIRGoogleMapUrlTile*)subview;
    tile.tileLayer.map = self;
    [self.tiles addObject:tile];
  } else {
    NSArray<id<ABI18_0_0RCTComponent>> *childSubviews = [subview ReactABI18_0_0Subviews];
    for (int i = 0; i < childSubviews.count; i++) {
      [self insertReactABI18_0_0Subview:(UIView *)childSubviews[i] atIndex:atIndex];
    }
  }
  [_ReactABI18_0_0Subviews insertObject:(UIView *)subview atIndex:(NSUInteger) atIndex];
}
#pragma clang diagnostic pop


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)removeReactABI18_0_0Subview:(id<ABI18_0_0RCTComponent>)subview {
  // similarly, when the children are being removed we have to do the appropriate
  // underlying mapview action here.
  if ([subview isKindOfClass:[ABI18_0_0AIRGoogleMapMarker class]]) {
    ABI18_0_0AIRGoogleMapMarker *marker = (ABI18_0_0AIRGoogleMapMarker*)subview;
    marker.realMarker.map = nil;
    [self.markers removeObject:marker];
  } else if ([subview isKindOfClass:[ABI18_0_0AIRGoogleMapPolygon class]]) {
    ABI18_0_0AIRGoogleMapPolygon *polygon = (ABI18_0_0AIRGoogleMapPolygon*)subview;
    polygon.polygon.map = nil;
    [self.polygons removeObject:polygon];
  } else if ([subview isKindOfClass:[ABI18_0_0AIRGoogleMapPolyline class]]) {
    ABI18_0_0AIRGoogleMapPolyline *polyline = (ABI18_0_0AIRGoogleMapPolyline*)subview;
    polyline.polyline.map = nil;
    [self.polylines removeObject:polyline];
  } else if ([subview isKindOfClass:[ABI18_0_0AIRGoogleMapCircle class]]) {
    ABI18_0_0AIRGoogleMapCircle *circle = (ABI18_0_0AIRGoogleMapCircle*)subview;
    circle.circle.map = nil;
    [self.circles removeObject:circle];
  } else if ([subview isKindOfClass:[ABI18_0_0AIRGoogleMapUrlTile class]]) {
    ABI18_0_0AIRGoogleMapUrlTile *tile = (ABI18_0_0AIRGoogleMapUrlTile*)subview;
    tile.tileLayer.map = nil;
    [self.tiles removeObject:tile];
  } else {
    NSArray<id<ABI18_0_0RCTComponent>> *childSubviews = [subview ReactABI18_0_0Subviews];
    for (int i = 0; i < childSubviews.count; i++) {
      [self removeReactABI18_0_0Subview:(UIView *)childSubviews[i]];
    }
  }
  [_ReactABI18_0_0Subviews removeObject:(UIView *)subview];
}
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (NSArray<id<ABI18_0_0RCTComponent>> *)ReactABI18_0_0Subviews {
  return _ReactABI18_0_0Subviews;
}
#pragma clang diagnostic pop

- (void)setInitialRegion:(MKCoordinateRegion)initialRegion {
  if (_initialRegionSet) return;
  _initialRegionSet = true;
  self.camera = [ABI18_0_0AIRGoogleMap makeGMSCameraPositionFromMap:self andMKCoordinateRegion:initialRegion];
}

- (void)setRegion:(MKCoordinateRegion)region {
  // TODO: The JS component is repeatedly setting region unnecessarily. We might want to deal with that in here.
  self.camera = [ABI18_0_0AIRGoogleMap makeGMSCameraPositionFromMap:self  andMKCoordinateRegion:region];
}

- (BOOL)didTapMarker:(GMSMarker *)marker {
  ABI18_0_0AIRGMSMarker *airMarker = (ABI18_0_0AIRGMSMarker *)marker;

  id event = @{@"action": @"marker-press",
               @"id": airMarker.identifier ?: @"unknown",
              };

  if (airMarker.onPress) airMarker.onPress(event);
  if (self.onMarkerPress) self.onMarkerPress(event);

  // TODO: not sure why this is necessary
  [self setSelectedMarker:marker];
  return NO;
}

- (void)didTapPolygon:(GMSOverlay *)polygon {
    ABI18_0_0AIRGMSPolygon *airPolygon = (ABI18_0_0AIRGMSPolygon *)polygon;

    id event = @{@"action": @"polygon-press",
                 @"id": airPolygon.identifier ?: @"unknown",
                 };

    if (airPolygon.onPress) airPolygon.onPress(event);
}

- (void)didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
  if (!self.onPress) return;
  self.onPress([self eventFromCoordinate:coordinate]);
}

- (void)didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
  if (!self.onLongPress) return;
  self.onLongPress([self eventFromCoordinate:coordinate]);
}

- (void)didChangeCameraPosition:(GMSCameraPosition *)position {
  id event = @{@"continuous": @YES,
               @"region": regionAsJSON([ABI18_0_0AIRGoogleMap makeGMSCameraPositionFromMap:self andGMSCameraPosition:position]),
               };

  if (self.onChange) self.onChange(event);
}

- (void)idleAtCameraPosition:(GMSCameraPosition *)position {
  id event = @{@"continuous": @NO,
               @"region": regionAsJSON([ABI18_0_0AIRGoogleMap makeGMSCameraPositionFromMap:self andGMSCameraPosition:position]),
               };
  if (self.onChange) self.onChange(event);  // complete
}


- (void)setScrollEnabled:(BOOL)scrollEnabled {
  self.settings.scrollGestures = scrollEnabled;
}

- (BOOL)scrollEnabled {
  return self.settings.scrollGestures;
}

- (void)setZoomEnabled:(BOOL)zoomEnabled {
  self.settings.zoomGestures = zoomEnabled;
}

- (BOOL)zoomEnabled {
  return self.settings.zoomGestures;
}

- (void)setRotateEnabled:(BOOL)rotateEnabled {
  self.settings.rotateGestures = rotateEnabled;
}

- (BOOL)rotateEnabled {
  return self.settings.rotateGestures;
}

- (void)setPitchEnabled:(BOOL)pitchEnabled {
  self.settings.tiltGestures = pitchEnabled;
}

- (BOOL)pitchEnabled {
  return self.settings.tiltGestures;
}

- (void)setShowsTraffic:(BOOL)showsTraffic {
  self.trafficEnabled = showsTraffic;
}

- (BOOL)showsTraffic {
  return self.trafficEnabled;
}

- (void)setShowsBuildings:(BOOL)showsBuildings {
  self.buildingsEnabled = showsBuildings;
}

- (BOOL)showsBuildings {
  return self.buildingsEnabled;
}

- (void)setShowsCompass:(BOOL)showsCompass {
  self.settings.compassButton = showsCompass;
}

- (void)setCustomMapStyleString:(NSString *)customMapStyleString {
  NSError *error;

  GMSMapStyle *style = [GMSMapStyle styleWithJSONString:customMapStyleString error:&error];

  if (!style) {
    NSLog(@"The style definition could not be loaded: %@", error);
  }

  self.mapStyle = style;
}

- (BOOL)showsCompass {
  return self.settings.compassButton;
}

- (void)setShowsUserLocation:(BOOL)showsUserLocation {
  self.myLocationEnabled = showsUserLocation;
}

- (BOOL)showsUserLocation {
  return self.myLocationEnabled;
}

- (void)setShowsMyLocationButton:(BOOL)showsMyLocationButton {
  self.settings.myLocationButton = showsMyLocationButton;
}

- (BOOL)showsMyLocationButton {
  return self.settings.myLocationButton;
}


+ (MKCoordinateRegion) makeGMSCameraPositionFromMap:(GMSMapView *)map andGMSCameraPosition:(GMSCameraPosition *)position {
  // solution from here: http://stackoverflow.com/a/16587735/1102215
  GMSVisibleRegion visibleRegion = map.projection.visibleRegion;
  GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithRegion: visibleRegion];
  CLLocationCoordinate2D center;
  CLLocationDegrees longitudeDelta;
  CLLocationDegrees latitudeDelta = bounds.northEast.latitude - bounds.southWest.latitude;

  if(bounds.northEast.longitude >= bounds.southWest.longitude) {
    //Standard case
    center = CLLocationCoordinate2DMake((bounds.southWest.latitude + bounds.northEast.latitude) / 2,
                                        (bounds.southWest.longitude + bounds.northEast.longitude) / 2);
    longitudeDelta = bounds.northEast.longitude - bounds.southWest.longitude;
  } else {
    //Region spans the international dateline
    center = CLLocationCoordinate2DMake((bounds.southWest.latitude + bounds.northEast.latitude) / 2,
                                        (bounds.southWest.longitude + bounds.northEast.longitude + 360) / 2);
    longitudeDelta = bounds.northEast.longitude + 360 - bounds.southWest.longitude;
  }
  MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
  return MKCoordinateRegionMake(center, span);
}

+ (GMSCameraPosition*) makeGMSCameraPositionFromMap:(GMSMapView *)map andMKCoordinateRegion:(MKCoordinateRegion)region {
  float latitudeDelta = region.span.latitudeDelta * 0.5;
  float longitudeDelta = region.span.longitudeDelta * 0.5;

  CLLocationCoordinate2D a = CLLocationCoordinate2DMake(region.center.latitude + latitudeDelta,
                                                        region.center.longitude + longitudeDelta);
  CLLocationCoordinate2D b = CLLocationCoordinate2DMake(region.center.latitude - latitudeDelta,
                                                        region.center.longitude - longitudeDelta);
  GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:a coordinate:b];
  return [map cameraForBounds:bounds insets:UIEdgeInsetsZero];
}

@end
