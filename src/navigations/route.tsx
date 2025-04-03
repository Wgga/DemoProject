import React from "react";
import { StatusBar } from "react-native";

import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { useFocusEffect, useNavigation } from "@react-navigation/native";

import Tabs from "../navigations/tabs";
import Page from "../navigations/page";

const Stack = createNativeStackNavigator();

function Route(): React.JSX.Element {
	const [isDarkMode, setIsDarkMode] = React.useState<boolean>(false);

	const navigation: any = useNavigation();

	useFocusEffect(
		React.useCallback(() => {
			// 监听路由变化改变状态栏颜色
			const urlRegex = [
				"",
			];
			// 监听Android物理返回按键
			const unsubscribe = navigation.addListener("state", () => {
				const isMatched = urlRegex.includes(navigation.getCurrentRoute().name);
				// 根据当前路由的URL来动态改变StatusBar的颜色
				setIsDarkMode(isMatched);
			});

			return () => {
				unsubscribe();
			};
		}, [isDarkMode])
	);

	return (
		<>
			<StatusBar
				barStyle={isDarkMode ? "light-content" : "dark-content"}
				backgroundColor="transparent"
				animated={true}
				translucent={true}
			/>
			<Stack.Navigator screenOptions={{ headerShown: false }}>
				<Stack.Screen name="Tabs" component={Tabs} />
				<Stack.Screen name="Page" component={Page} />
			</Stack.Navigator>
		</>
	);
}

export default Route;