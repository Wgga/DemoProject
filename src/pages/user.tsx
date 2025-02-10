import React from "react";

import { View, Text, StyleSheet, Pressable, FlatList } from "react-native";

import { useSafeAreaInsets } from "react-native-safe-area-context";

function User({ navigation, route }: any): React.JSX.Element {

	// 控件
	const insets = useSafeAreaInsets();
	// 参数
	// 变量
	let items = React.useRef<any[]>([
		{ id: 1, text: "赵" },
		{ id: 2, text: "钱" },
		{ id: 3, text: "孙" },
		{ id: 4, text: "李" },
		{ id: 5, text: "周" },
		{ id: 6, text: "吴" },
		{ id: 7, text: "郑" },
		{ id: 8, text: "王" },
		{ id: 9, text: "冯" },
		{ id: 10, text: "陈" },
		{ id: 11, text: "褚" },
		{ id: 12, text: "卫" },
		{ id: 13, text: "蒋" },
		{ id: 14, text: "沈" },
		{ id: 15, text: "韩" },
		{ id: 16, text: "杨" },
		{ id: 17, text: "朱" },
		{ id: 18, text: "秦" },
		{ id: 19, text: "尤" },
		{ id: 20, text: "许" },
		{ id: 21, text: "何" },
		{ id: 22, text: "吕" },
		{ id: 23, text: "施" },
		{ id: 24, text: "张" },
	])
	// 数据
	// 状态

	return (
		<View style={{ flex: 1, justifyContent: "center", alignItems: "center", paddingTop: insets.top }}>
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
	);
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

export default User;