import React from "react";

import { View, Text, StyleSheet, Pressable, Button, useWindowDimensions, Dimensions, UIManager, findNodeHandle } from "react-native";

import { useSafeAreaInsets } from "react-native-safe-area-context";
import HomeListView from "home-list-view/HomeListViewNativeComponent";

function Home({ navigation, route }: any): React.JSX.Element {

	// 控件
	const insets = useSafeAreaInsets();
	const listRef = React.useRef<any>(null);
	const { width, height } = useWindowDimensions();
	// 参数
	// 变量
	const [index, setIndex] = React.useState(0);
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
		<View style={{ flex: 1, backgroundColor: "#fff" }}>
			<HomeListView ref={listRef}
				src="home"
				contentHeight={JSON.stringify(724.84)}
				tabData={["最新", "专题", "寻味", "知识"]}
				onLoadEnd={(ev: any) => {
					UIManager.dispatchViewManagerCommand(
						findNodeHandle(listRef.current),
						"setArticleListData",
						[]
					)
					console.log("%c Line:1001 🍇 onLoadEnd", "color:#33a5ff", ev.nativeEvent);
				}}
				onReachEnd={(ev: any) => {
					UIManager.dispatchViewManagerCommand(
						findNodeHandle(listRef.current),
						"loadMoreArticleListData",
						[]
					)
					console.log("%c Line:1008 🍩 onReachEnd", "color:#3f7cff", ev.nativeEvent);
				}}
				onGotoDetail={(ev: any) => {
					console.log("%c Line:1016 🍪 onGotoDetail", "color:#f5ce50", ev.nativeEvent);
				}}
			/>
		</View>
	)
}

const styles = StyleSheet.create({
});

export default Home;