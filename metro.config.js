const { getDefaultConfig, mergeConfig } = require('@react-native/metro-config');
const { createHarmonyMetroConfig } = require('@react-native-oh/react-native-harmony/metro.config');

const defaultConfig = getDefaultConfig(__dirname);
const { assetExts, sourceExts } = defaultConfig.resolver;

/**
 * Metro configuration
 * https://facebook.github.io/metro/docs/configuration
 *
 * @type {import('metro-config').ConfigT}
 */
const config = {
	transformer: {
		babelTransformerPath: require.resolve("react-native-svg-transformer/react-native"),
		getTransformOptions: async () => ({
			transform: {
				experimentalImportSupport: false,
				inlineRequires: true
			},
		}),
	},
	resolver: {
		assetExts: assetExts.filter(ext => ext !== "svg"),
		sourceExts: [...sourceExts, "svg"],
	}
};

module.exports = mergeConfig(getDefaultConfig(__dirname), createHarmonyMetroConfig({
	reactNativeHarmonyPackageName: '@react-native-oh/react-native-harmony',
}), config);
