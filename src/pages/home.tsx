import React from "react";

import { View, Text, StyleSheet, Pressable, FlatList, Image, useWindowDimensions, UIManager, findNodeHandle } from "react-native";

import { useSafeAreaInsets } from "react-native-safe-area-context";
import ShadowImage from "@react-native-hmos/nosetime-shadow-image";

import Analysis from "../assets/svg/analysis.svg";
import Bottle1 from "../assets/svg/bottle1.svg";
import HomeList from "@react-native-hmos/nosetime-home-list";

function Home({ navigation, route }: any): React.JSX.Element {

	// 控件
	const insets = useSafeAreaInsets();
	const { height } = useWindowDimensions();
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
	let index = React.useRef<number>(0);
	let list = React.useRef<any[]>([]);
	let morelist = React.useRef<any[]>([]);
	let noMore = React.useRef<boolean>(false);

	React.useEffect(() => {
		list.current = [...items]; morelist.current = list.current.splice(12, 1000);
		setListData();
	}, [])

	const setListData = () => {
		if (list.current.length > 0) {
			UIManager.dispatchViewManagerCommand(
				findNodeHandle(listRef.current),
				"setListData",
				[{ items: list.current, noMore: noMore.current }]
			)
		}
	}

	// 加载下一页
	const onReachEnd = ({ nativeEvent }: any) => {
		if (morelist.current) {
			let morelist2 = [];
			morelist2.push(...morelist.current.slice(index.current * 12, index.current * 12 + 12))
			index.current++;
			list.current = list.current.concat(morelist2);
			noMore.current = (morelist2.length < 10);
			setTimeout(() => setListData(), 1000);
		}
	}

	// 点击事件
	const onClick = ({ nativeEvent: { type, data } }: any) => {
		const params = JSON.parse(data);
		if (type === "postDiscussUp") {
			if (params.type === 1) {
				const index = list.current.findIndex((item: any) => item.id === params.item.id);
				list.current[index].up = (Number(list.current[index].up) + 1).toString();
				UIManager.dispatchViewManagerCommand(
					findNodeHandle(listRef.current),
					"setItemUp",
					[list.current[index]]
				)
			}
		}
	}

	return (
		<View style={{ flex: 1, paddingTop: insets.top }}>
			<Text>咨询问题：RN框架下使用Fabric自定义组件渲染的列表，点击点赞按钮对应的up值增加，当滑动到底部加载下一页时，点击第二页任意一个点赞按钮对应的up值能正常增加，这时点击上一页的某个点赞按钮时对应的up数值不会增加了</Text>
			<HomeList ref={listRef} style={{ flex: 1 }}
				contentHeight={JSON.stringify(height - (insets.bottom + 48))}
				tabData={[""]}
				onReachEnd={onReachEnd}
				onClick={onClick}
			/>
		</View>
	)
}

const styles = StyleSheet.create({
});

export default Home;