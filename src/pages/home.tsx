import React from "react";

import { View, Text, StyleSheet, Pressable, Button, useWindowDimensions, Dimensions, UIManager, findNodeHandle, TextInput, FlatList } from "react-native";

import { useSafeAreaInsets } from "react-native-safe-area-context";

function Home({ navigation, route }: any): React.JSX.Element {

	// 控件
	const insets = useSafeAreaInsets();
	const listRef = React.useRef<any>(null);
	const { width, height } = useWindowDimensions();
	// 参数
	// 变量
	const [index, setIndex] = React.useState(0);
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
	// 数据
	const [routes] = React.useState([
		{ key: "tab1", title: "Tab1" },
		{ key: "tab2", title: "Tab2" },
	]);
	// 数据
	const banner: any[] = [
		{
			"id": "1",
			"img": "/banner/202403/660232c37ece5.jpg",
			"title": "MBTI 16人格香水指南",
			"subtitle": "哪支香与你匹配？",
			"page": "article-detail",
			"code": "672"
		},
		{
			"id": "2",
			"img": "/banner/202407/yezi634.jpg",
			"title": "8支「椰子香水」",
			"subtitle": "撩进心窝的治愈奶香",
			"page": "article-detail",
			"code": "634"
		},
		{
			"id": "3",
			"img": "/banner/202410/xingbie718.jpg",
			"title": "香水为什么会有性别之分？",
			"subtitle": "",
			"page": "article-detail",
			"code": "718"
		},
		{
			"id": "4",
			"img": "/banner/202411/guihua727.jpg",
			"title": "「桂花香水」TOP9",
			"subtitle": "寻找记忆里的一抹甜蜜!",
			"page": "article-detail",
			"code": "727"
		},
		{
			"id": "5",
			"img": "/banner/202410/1a2bae8ad8128cb18d2e8aca9296a60a.jpg",
			"title": "8支「药感香水」",
			"subtitle": "一闻就爱上的迷人苦味",
			"page": "article-detail",
			"code": "707"
		}
	]
	// 状态
	const [isrender, setIsRender] = React.useState<boolean>(false);

	return (
		<View style={{ flex: 1, paddingTop: insets.top }}>
			<Text>Bug: 首次进入Tab页面，频繁切换Tab，然后点击下方列表item进入详情页，点击详情页任意位置（非输入框位置）会先触发键盘弹起</Text>
			<FlatList data={items.current} bounces={false}
				showsVerticalScrollIndicator={false}
				keyExtractor={(item) => item.id}
				renderItem={({ item }) => {
					return (
						<Pressable style={styles.list_item} onPress={() => {
							navigation.navigate("Page", { screen: "Detail2", params: { title: item.text } });
						}}>
							<Text>{item.text}</Text>
						</Pressable>
					)
				}} />
		</View>
	)
}

const styles = StyleSheet.create({
	list_item: {
		width: "100%",
		justifyContent: "center",
		alignItems: "center",
		padding: 50,
		borderWidth: 1,
		borderColor: "#000",
		borderBottomWidth: 0,
	}
});

export default Home;