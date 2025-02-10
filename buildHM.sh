#!/bin/bash

# 删除bundle包文件
rm -rf ./harmony/entry/src/main/resources/rawfile/bundle.harmony.js
rm -rf ./harmony/entry/src/main/resources/rawfile/hermes_bundle.hbc
echo "bundle包文件删除完毕"

# # 执行getJson.js文件，生成字体文件
# node ./src/assets/fonts/getJson.js
# echo "字体文件生成完毕"

# 生成bundle包文件
npm run codegen
npx react-native bundle-harmony --dev false
echo "bundle包文件生成完毕"

# 拷贝bundle包文件到hermesc目录下
cp ./harmony/entry/src/main/resources/rawfile/bundle.harmony.js node_modules/react-native/sdks/hermesc/osx-bin
echo "bundle包文件拷贝完毕"

# 切换到hermesc目录下
cd node_modules/react-native/sdks/hermesc/osx-bin

# 执行编译命令，生成hbc文件
./hermesc --emit-binary bundle.harmony.js -out hermes_bundle.hbc
echo "hbc文件编译完毕"

# 将hbc文件拷贝到nosetime-hm目录下
cp hermes_bundle.hbc ../../../../../harmony/entry/src/main/resources/rawfile/
echo "hbc文件拷贝完毕"

# 删除临时文件
rm -rf bundle.harmony.js
rm -rf hermes_bundle.hbc
echo "临时文件删除完毕"

# 返回上一级目录
cd ../../../../../
