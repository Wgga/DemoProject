#include "RNOH/PackageProvider.h"
#include "generated/RNOHGeneratedPackage.h"
#include "GestureHandlerPackage.h"
#include "ViewPagerPackage.h"
#include "ReanimatedPackage.h"
#include "SafeAreaViewPackage.h"

using namespace rnoh;

std::vector<std::shared_ptr<Package>> PackageProvider::getPackages(Package::Context ctx) {
    return {
        std::make_shared<RNOHGeneratedPackage>(ctx),
        std::make_shared<GestureHandlerPackage>(ctx),
        std::make_shared<ViewPagerPackage>(ctx),
        std::make_shared<ReanimatedPackage>(ctx),
        std::make_shared<SafeAreaViewPackage>(ctx),
    };
}