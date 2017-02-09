// @flow
const path = require('path');
const {
  sourcePaths,
  webpackBaseConfig,
  webpackLoaderRules,
} = require('../build_utils');

module.exports = {
  entry: [
    path.resolve(sourcePaths.frontend, 'spec.js'),
  ],
  externals: webpackBaseConfig.externals,
  module: {
    rules: [
      webpackLoaderRules.js,
    ],
  },
  node: undefined,
  output: {
    filename: 'index.js',
    path: path.resolve(__dirname, 'src', 'gen'),
  },
  plugins: undefined,
  resolve: webpackBaseConfig.resolve,
  stats: 'errors-only',
  target: 'node',
};
