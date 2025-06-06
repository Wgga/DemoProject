import React from "react";

import { View, Text, StyleSheet, Pressable, FlatList, Image } from "react-native";

import { useSafeAreaInsets } from "react-native-safe-area-context";
import ShadowImage from "@react-native-hmos/nosetime-shadow-image";

import Analysis from "../assets/analysis.svg";
import Bottle1 from "../assets/bottle1.svg";

function Home({ navigation, route }: any): React.JSX.Element {

	// 控件
	const insets = useSafeAreaInsets();
	// 参数
	let imageList = [
		{ name: "brand.jpg", url: require("../assets/brand.jpg") },
		{ name: "default_avatar.png", url: require("../assets/default_avatar.png") },
		{ name: "lottery.gif", url: require("../assets/lottery.gif") },
	]
	// 变量
	let items = React.useRef<any[]>([
		{ id: 1, text: "孔" },
		{ id: 2, text: "曹" },
		{ id: 3, text: "严" },
		{ id: 4, text: "华" },
		{ id: 5, text: "金" },
		{ id: 6, text: "魏" },
		{ id: 7, text: "陶" },
		{ id: 8, text: "姜" },
		{ id: 9, text: "戚" },
		{ id: 10, text: "谢" },
		{ id: 11, text: "邹" },
		{ id: 12, text: "喻" },
		{ id: 13, text: "柏" },
		{ id: 14, text: "水" },
		{ id: 15, text: "窦" },
		{ id: 16, text: "章" },
		{ id: 17, text: "云" },
		{ id: 18, text: "苏" },
		{ id: 19, text: "潘" },
		{ id: 20, text: "葛" },
		{ id: 21, text: "奚" },
		{ id: 22, text: "范" },
		{ id: 23, text: "彭" },
		{ id: 24, text: "郎" },
	])

	return (
		<View style={{ flex: 1, paddingTop: insets.top }}>
			<Text>咨询问题：在使用react-native bundle-harmony --dev打包RN项目时/src/assets目录下png/jpg/gif图片都能打包进harmony/entry/src/main/resources/rawfile目录下，svg图片打包不进去, 导致鸿蒙侧渲染不出来</Text>
			<View style={{ marginVertical: 20 }}>
				<Text>RN侧渲染</Text>
				<View style={{ flexDirection: "row", flexWrap: "wrap" }}>
					<View style={styles.img_con}>
						<Analysis width={100} height={100} />
						<Text>{"analysis.svg"}</Text>
					</View>
					{imageList.map((item, index) => <View key={item.name} style={styles.img_con}>
						<Image source={item.url} style={{ width: 100, height: 100 }} />
						<Text>{item.name}</Text>
					</View>)}
				</View>
			</View>
			<View>
				<Text>鸿蒙侧渲染（使用的是TurboModule自定义组件）</Text>
				<View style={{ flexDirection: "row", flexWrap: "wrap", width: "100%" }}>
					<View style={[styles.img_con, { width: 100, height: 100 }]}>
						<ShadowImage style={{ flex: 1 }}
							ImageConfig={{
								source: "analysis.svg",
								width: "100",
								height: "100",
								resizeMode: "contain",
							}}
						/>
						<Text>{"analysis.svg"}</Text>
					</View>
					{imageList.map((item, index) => <View key={item.name}
						style={styles.img_con}>
						<ShadowImage style={{ flex: 1 }}
							ImageConfig={{
								source: item.name,
								width: "100",
								height: "100",
								resizeMode: "cover",
							}}
						/>
						<Text>{item.name}</Text>
					</View>)}
				</View>
			</View>
		</View>
	)
}

const styles = StyleSheet.create({
	img_con: {
		width: 120,
		height: 120,
		alignItems: "center",
		margin: 5,
		borderWidth: 1
	}
});

export default Home;