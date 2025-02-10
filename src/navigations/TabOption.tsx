import React from "react";
import { StyleSheet, Text } from "react-native";

// TabOption 配置
const TabOption = (route: any) => {
	return {
		headerShown: false,
		tabBarActiveTintColor: "#5763BD",
		tabBarInactiveTintColor: "#4D4D4D",
		tabBarLabel: ({ focused, color, children }: any) => {
			// if (route.name === "Social" && focused) {
			// 	return ""; // 设置空标题
			// }
			return <Text style={{ color: color, fontSize: 12, fontWeight: "500" }}>{children}</Text>; // 其他情况返回默认标题
		},
		tabBarIconStyle: {
			flex: 1,
		},
	}
};
const styles = StyleSheet.create({
	iconsvg: {
		width: 22,
		height: 22,
	},
	iconhome: {
		width: 30,
		height: 30,
	},
	iconsocialcon: {
		width: 63,
		height: 63,
		backgroundColor: "#FFF",
		justifyContent: "center",
		alignItems: "center",
		borderRadius: 31.5,
		top: -3
	},
	iconsocial: {
		width: 50,
		height: 50,
	},
	btn_badge: {
		width: 12,
		height: 12,
	}
});
export default TabOption;