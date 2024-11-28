#import <YouTubeHeader/YTIGuideResponse.h>
#import <YouTubeHeader/YTIGuideResponseSupportedRenderers.h>
#import <YouTubeHeader/YTIPivotBarSupportedRenderers.h>
#import <YouTubeHeader/YTIPivotBarRenderer.h>
#import <YouTubeHeader/YTIBrowseRequest.h>

static void hideTabs(YTIGuideResponse *response) {
    Class YTIBrowseRequestClass = %c(YTIBrowseRequest);
    NSMutableArray <YTIGuideResponseSupportedRenderers *> *renderers = [response itemsArray];
    for (YTIGuideResponseSupportedRenderers *guideRenderers in renderers) {
        YTIPivotBarRenderer *pivotBarRenderer = [guideRenderers pivotBarRenderer];
        NSMutableArray <YTIPivotBarSupportedRenderers *> *items = [pivotBarRenderer itemsArray];
        if (items.count == 0) continue;
        NSMutableIndexSet *indexesToRemove = [NSMutableIndexSet indexSet];
        for (NSUInteger index = 0; index < items.count; ++index) {
            YTIPivotBarSupportedRenderers *renderers = items[index];
            NSString *identifier = [[renderers pivotBarItemRenderer] pivotIdentifier];
            if (!identifier.length) identifier = [[renderers pivotBarIconOnlyItemRenderer] pivotIdentifier];
            if ([identifier isEqualToString:@"FEshorts"])
                [indexesToRemove addIndex:index];
            else if ([identifier isEqualToString:@"FEuploads"])
                [indexesToRemove addIndex:index];
            else if ([identifier isEqualToString:[YTIBrowseRequestClass browseIDForExploreTab]])
                [indexesToRemove addIndex:index];
            else if ([identifier isEqualToString:[YTIBrowseRequestClass browseIDForHomeTab]])
                [indexesToRemove addIndex:index];
            else if ([identifier isEqualToString:[YTIBrowseRequestClass browseIDForLibraryTab]])
                [indexesToRemove addIndex:index];
            else if ([identifier isEqualToString:[YTIBrowseRequestClass browseIDForTrendingTab]])
                [indexesToRemove addIndex:index];
            else if ([identifier isEqualToString:[YTIBrowseRequestClass browseIDForSubscriptionsTab]])
                [indexesToRemove addIndex:index];
        }
        [items removeObjectsAtIndexes:indexesToRemove];
    }
}

%hook YTGuideServiceCoordinator

- (void)handleResponse:(YTIGuideResponse *)response withCompletion:(id)completion {
    hideTabs(response);
    %orig;
}

- (void)handleResponse:(YTIGuideResponse *)response error:(id)error completion:(id)completion {
    hideTabs(response);
    %orig;
}

%end

%hook YTAppGuideServiceCoordinator

// hide usless tabs (https://github.com/PoomSmart/YouHideTabs)
- (void)handleResponse:(YTIGuideResponse *)response error:(id)error completion:(id)completion {
    hideTabs(response);
    %orig;
}

%end