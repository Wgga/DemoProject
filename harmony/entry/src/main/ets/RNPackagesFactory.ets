import { RNPackageContext, RNPackage } from '@rnoh/react-native-openharmony/ts';

import { GestureHandlerPackage } from '@react-native-oh-tpl/react-native-gesture-handler/ts';
import { ViewPagerPackage } from '@react-native-oh-tpl/react-native-pager-view/ts';
import { ReanimatedPackage } from '@react-native-oh-tpl/react-native-reanimated/ts';
import { SafeAreaViewPackage } from '@react-native-oh-tpl/react-native-safe-area-context/ts';


export function createRNPackages(ctx: RNPackageContext): RNPackage[] {
  return [
    new GestureHandlerPackage(ctx),
    new ViewPagerPackage(ctx),
    new ReanimatedPackage(ctx),
    new SafeAreaViewPackage(ctx)
  ];
}