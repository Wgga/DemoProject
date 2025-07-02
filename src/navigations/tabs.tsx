import React from "react";
import { StyleSheet } from "react-native";

import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";

import TabOption from "./TabOption";
import Home from "../pages/home";
import User from "../pages/user";

const Tab = createBottomTabNavigator();

function Tabs({ navigation, route }: any): React.JSX.Element {
	// 控件
	let socialfid = React.useRef<number>(0);
	const [ShowBadge, setShowBadge] = React.useState<boolean>(false);

	return (
		<>
			<Tab.Navigator screenOptions={({ route }: any) => ({
				...TabOption(route),
				tabBarStyle: {
					shadowColor: "transparent",
					borderColor: "transparent",
					display: "none",
					// height: 56,
				},
				tabBarItemStyle: {
					borderColor: "transparent",
					flexDirection: "column",
					// marginBottom: 5,
				},
			})}>
				<Tab.Screen name="Home" options={{ title: "首页" }} component={Home} />
				<Tab.Screen name="User" options={{ title: "我的" }} component={User} />
			</Tab.Navigator>
		</>
	);
}

const styles = StyleSheet.create({
})

export default Tabs;

