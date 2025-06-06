import React from "react";

import { View, Text, StyleSheet, TextInput, KeyboardAvoidingView, ScrollView, useWindowDimensions } from "react-native";

import Animated, { useAnimatedStyle, useSharedValue, withTiming } from "react-native-reanimated";
import { useSafeAreaInsets } from "react-native-safe-area-context";

function Detail2({ navigation, route }: any): React.JSX.Element {

	// 控件
	const insets = useSafeAreaInsets();
	const { width, height } = useWindowDimensions();
	console.log("%c Line:13 🍊 width, height", "color:#f5ce50", width, height);
	// 参数
	// 变量
	let headerOpt = useSharedValue(0); // 头部透明度动画
	// 数据
	// 状态
	let isShowHeader = React.useRef<boolean>(false); // 是否显示头部

	const showHeaderView = (e: any) => {
		if (e.nativeEvent.contentOffset.y > 100) {
			if (isShowHeader.current) return;
			isShowHeader.current = true;
			headerOpt.modify(() => {
				'worklet';
				return 1;
			})
		} else {
			if (!isShowHeader.current) return;
			isShowHeader.current = false;
			headerOpt.modify(() => {
				'worklet';
				return 0;
			})
		}
	}

	return (
		<KeyboardAvoidingView style={{ flex: 1, backgroundColor: "#fff", paddingTop: insets.top }} keyboardVerticalOffset={0} behavior="height">
			<ScrollView onScroll={showHeaderView}>
				<Text style={{ height: 1500 }}>Bug: 键盘顶不起输入框</Text>
			</ScrollView>
			<Animated.View style={[styles.footer_container, useAnimatedStyle(() => ({
				opacity: withTiming(headerOpt.value, { duration: 300 }),
				zIndex: headerOpt.value ? 13 : -2
			}))]}>
				<View style={[styles.footer_con, { paddingBottom: insets.bottom + 10 }]}>
					<View style={styles.footer_con_left}>
						<TextInput style={styles.footer_input}
							multiline={true}
						/>
					</View>
				</View>
			</Animated.View>
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