import React from "react";
import { createNativeStackNavigator } from "@react-navigation/native-stack";

import Detail from "../pages/Detail";
import Detail2 from "../pages/Detail2";

const Stack = createNativeStackNavigator();

function Page(): React.JSX.Element {
	return (
		<Stack.Navigator screenOptions={{ headerShown: false }}>
			<Stack.Screen name="Detail" component={Detail} />
			<Stack.Screen name="Detail2" component={Detail2} />
		</Stack.Navigator>
	);
}

export default Page;