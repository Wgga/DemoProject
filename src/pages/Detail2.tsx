import React from "react";

import { View, Text, StyleSheet, TextInput, KeyboardAvoidingView } from "react-native";

import { useSafeAreaInsets } from "react-native-safe-area-context";

function Detail2({ navigation, route }: any): React.JSX.Element {

	// 控件
	const insets = useSafeAreaInsets();
	// 参数
	// 变量
	// 数据
	// 状态

	return (
		<KeyboardAvoidingView style={{ flex: 1, backgroundColor: "#fff", paddingTop: insets.top }}>
			<Text>Bug: 键盘顶不起输入框</Text>
			<View style={styles.footer_container}>
				<View style={[styles.footer_con, { paddingBottom: insets.bottom + 10 }]}>
					<View style={styles.footer_con_left}>
						<TextInput style={styles.footer_input}
							multiline={true}
						/>
					</View>
				</View>
			</View>
		</KeyboardAvoidingView>
	)
}

const styles = StyleSheet.create({
	footer_container: {
		position: "absolute",
		left: 0,
		right: 0,
		bottom: 0,
		zIndex: 13,
	},
	footer_con: {
		flexDirection: "row",
		alignItems: "center",
		backgroundColor: "#FFF",
		borderTopWidth: 1,
		borderTopColor: "#F5F5F5",
		paddingTop: 15,
		paddingHorizontal: 24,
	},
	footer_con_left: {
		flex: 1,
		backgroundColor: "#F5F5F5",
		borderRadius: 20,
		paddingLeft: 12,
		paddingRight: 5,
	},
	footer_input: {
		position: "relative",
		zIndex: 0,
		paddingTop: 10,
		paddingBottom: 10,
		lineHeight: 18,
		fontSize: 13,
	},
})

export default Detail2;