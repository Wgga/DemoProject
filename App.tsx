/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React from "react";
import { StyleSheet, Text } from "react-native";//注入组件

import { NavigationContainer } from "@react-navigation/native";
import { SafeAreaProvider } from "react-native-safe-area-context";

import Route from "./src/navigations/route";
import { ModalPortal } from "./src/modals";

function App(): React.JSX.Element {

	return (
		<SafeAreaProvider>
			<React.Fragment>
				<NavigationContainer>
					<Route />
				</NavigationContainer>
				<ModalPortal />
			</React.Fragment>
		</SafeAreaProvider>
	);
}

const styles = StyleSheet.create({

});

export default App;
