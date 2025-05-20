import React from "react";

import { View, Text, StyleSheet, Pressable, FlatList } from "react-native";

import { useSafeAreaInsets } from "react-native-safe-area-context";

function Home({ navigation, route }: any): React.JSX.Element {

	// 控件
	const insets = useSafeAreaInsets();
	// 参数
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
			<Text>Bug: 键盘顶不起输入框</Text>
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