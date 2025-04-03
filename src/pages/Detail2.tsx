import React from "react";

import { View, Text, StyleSheet, Pressable, TextInput } from "react-native";

import { useSafeAreaInsets } from "react-native-safe-area-context";

function Detail2({ navigation, route }: any): React.JSX.Element {

	// 控件
	const insets = useSafeAreaInsets();
	// 参数
	// 变量
	// 数据
	// 状态

	return (
		<View style={{ flex: 1, backgroundColor: "#fff", paddingTop: insets.top }}>
			<Text>Bug: 点击空白键盘会弹起</Text>
			<TextInput style={styles.input_con} />
		</View>
	)
}

const styles = StyleSheet.create({
	input_con: {
		position: "relative",
		zIndex: 0,
		paddingTop: 10,
		paddingBottom: 10,
		maxHeight: 100,
		lineHeight: 18,
		fontSize: 13,
		backgroundColor: "#F5F5F5",
		marginTop: 300,
	},
})

export default Detail2;