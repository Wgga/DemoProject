import React from "react";

import { View, Text, StyleSheet, useWindowDimensions } from "react-native";

import { useSafeAreaInsets } from "react-native-safe-area-context";
import Carousel from "react-native-reanimated-carousel";

function Home({ navigation, route }: any): React.JSX.Element {

	// 控件
	const insets = useSafeAreaInsets();
	const { width, height } = useWindowDimensions();
	const listRef = React.useRef<any>(null);
	// 参数
	const items = [
		{ "id": 1, "name": "赵", "up": "1" },
		{ "id": 2, "name": "钱", "up": "10" },
		{ "id": 3, "name": "孙", "up": "4" },
		{ "id": 4, "name": "李", "up": "4" },
		{ "id": 5, "name": "周", "up": "9" },
		{ "id": 6, "name": "吴", "up": "8" },
		{ "id": 7, "name": "郑", "up": "3" },
		{ "id": 8, "name": "王", "up": "7" },
		{ "id": 9, "name": "冯", "up": "6" },
		{ "id": 10, "name": "陈", "up": "9" },
		{ "id": 11, "name": "褚", "up": "10" },
		{ "id": 12, "name": "卫", "up": "3" },
		{ "id": 13, "name": "蒋", "up": "4" },
		{ "id": 14, "name": "沈", "up": "1" },
		{ "id": 15, "name": "韩", "up": "10" },
		{ "id": 16, "name": "杨", "up": "7" },
		{ "id": 17, "name": "朱", "up": "8" },
		{ "id": 18, "name": "秦", "up": "3" },
		{ "id": 19, "name": "尤", "up": "3" },
		{ "id": 20, "name": "许", "up": "5" },
		{ "id": 21, "name": "何", "up": "8" },
		{ "id": 22, "name": "吕", "up": "4" },
		{ "id": 23, "name": "施", "up": "1" },
		{ "id": 24, "name": "张", "up": "8" },
		{ "id": 25, "name": "孔", "up": "9" },
		{ "id": 26, "name": "曹", "up": "10" },
		{ "id": 27, "name": "严", "up": "6" },
		{ "id": 28, "name": "华", "up": "9" },
		{ "id": 29, "name": "金", "up": "6" },
		{ "id": 30, "name": "魏", "up": "5" },
		{ "id": 31, "name": "陶", "up": "5" },
		{ "id": 32, "name": "姜", "up": "10" },
		{ "id": 33, "name": "戚", "up": "1" },
		{ "id": 34, "name": "谢", "up": "7" },
		{ "id": 35, "name": "邹", "up": "10" },
		{ "id": 36, "name": "喻", "up": "3" },
		{ "id": 37, "name": "柏", "up": "9" },
		{ "id": 38, "name": "水", "up": "3" },
		{ "id": 39, "name": "窦", "up": "7" },
		{ "id": 40, "name": "章", "up": "3" },
		{ "id": 41, "name": "云", "up": "3" },
		{ "id": 42, "name": "苏", "up": "8" },
		{ "id": 43, "name": "潘", "up": "6" },
		{ "id": 44, "name": "葛", "up": "1" },
		{ "id": 45, "name": "奚", "up": "1" },
		{ "id": 46, "name": "范", "up": "5" },
		{ "id": 47, "name": "彭", "up": "7" },
		{ "id": 48, "name": "郎", "up": "9" },
		{ "id": 49, "name": "鲁", "up": "10" },
		{ "id": 50, "name": "韦", "up": "6" },
	]
	// 变量

	return (
		<View style={styles.container}>
			<Text style={{ marginTop: insets.top }}>{"问题描述：RN框架在【@rnoh/react-native-openharmony】0.72.70以上版本下使用react-native-reanimated-carousel组件，轮播图滑动手势有问题，在部分区域滑动手势不可用, 红线框为轮播图整个容器区域"}</Text>
			<View style={{ marginBottom: insets.bottom + 73 }}>
				<View style={[StyleSheet.absoluteFillObject, { zIndex: 0 }]}>
					<View style={[styles.region, styles.top]}>
						<Text>{"在此区域轮播图滑动手势不可用"}</Text>
					</View>
					<View style={styles.region}>
						<Text>{"在此区域轮播图滑动手势可用"}</Text>
					</View>
				</View>
				<Carousel key={width}
					width={width}
					data={items}
					defaultIndex={0}
					autoPlayInterval={3000}
					scrollAnimationDuration={500}
					autoPlay={false}
					autoFillData
					loop={false}
					style={styles.carousel}
					renderItem={({ item, index }: any) => (
						<View style={[styles.item, index % 2 == 0 && { backgroundColor: "rgba(178, 128, 225, 0.8)" }]}>
							<Text>{item.id} {item.name}</Text>
						</View>
					)}
				/>
			</View>
		</View>
	)
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
	},
	carousel: {
		borderWidth: 1,
		borderColor: "red",
	},
	item: {
		width: "100%",
		height: 200,
		alignItems: "center",
		justifyContent: "center",
		backgroundColor: "rgba(255, 192, 203, 0.8)",
	},
	region: {
		flex: 1,
		borderWidth: 1,
		alignItems: "center",
		justifyContent: "center"
	},
	top: {
		flex: 1.4,
		borderBottomWidth: 0,
	},
});

export default Home;