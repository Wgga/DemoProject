// Copyright (c) 2024 Huawei Device Co., Ltd. All rights reserved
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import { rcp } from '@kit.RemoteCommunicationKit';
import { fileIo, fileUri } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';

import StorageUtils from '../utils/StorageUtils';

export interface SplashDataProps {
  id: string;
  spurl: string;
  spname: string;
  sptype: string;
  duration: string;
  filePath?: string;
}

export class SplashScreen {
  static NAME = "SplashScreen"
  // 启动图片
  public static splashData: SplashDataProps;
  public static splashUrl: string | Resource = $r('app.media.background');
  public static duration: number = 3000;

  /**
   * 设置启动页图片
   */
  public static async setSplashImage() {
    const storage = new StorageUtils();
    try {
      const cacheString: string = await storage.getItem("splashData");
      const splashData: SplashDataProps = JSON.parse(cacheString);
      if (splashData && splashData.filePath) {
        const isExist: boolean = await fileIo.access(splashData.filePath);
        SplashScreen.splashUrl = isExist ? fileUri.getUriFromPath(splashData.filePath) : $r('app.media.background');
        SplashScreen.duration = splashData.duration ? Number(splashData.duration) : 3000;
      }
    } catch (err) {
      SplashScreen.splashUrl = $r('app.media.background');
      SplashScreen.duration = 3000;
    }
  }

  /**
   * 若新获取的图片和缓存内的图片不同则删除缓存内的图片
   */
  private static async clearSplashImage(filePath: string | undefined) {
    try {
      await fileIo.unlink(filePath);
    } catch (err) {
      console.error("==== SplashScreen clearSplashImage delete failed error: " + JSON.stringify(err));
    }
  }

  /**
   * 缓存启动页图片
   */
  public static async cacheSplashImage() {
    const session = rcp.createSession();
    const getURL = "http://192.168.2.21/app/splash.php?method=getsplashurl";
    try {
      const result: rcp.Response = await session.get(getURL);
      const storage = new StorageUtils();
      const splashData: SplashDataProps = JSON.parse(JSON.stringify(result));
      storage.getItem("splashData").then((cacheString: string) => {
        if (cacheString) {
          const cacheData: SplashDataProps = JSON.parse(cacheString);
          if (cacheData && splashData && cacheData.id !== splashData.id) {
            SplashScreen.clearSplashImage(cacheData.filePath);
            storage.removeItem("splashData");
          }
        }
      }).catch(() => {
      });
      if (splashData && splashData.spurl) {
        const splashUrl: string = "img.xssdcdn.com" + splashData.spurl;
        const path: string = getContext().filesDir;
        await session.downloadToFile(`https://${splashUrl}`, { kind: "folder", path });
        splashData.filePath = `${path}/${splashUrl}`;
        storage.saveItem("splashData", JSON.stringify(splashData));
      }
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      console.error("==== SplashScreen error: " + JSON.stringify(error));
    }
  }
}
