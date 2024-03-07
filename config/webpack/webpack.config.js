// See the shakacode/shakapacker README and docs directory for advice on customizing your webpackConfig.
const { generateWebpackConfig } = require('shakapacker')
const Dotenv = require('dotenv-webpack');

const webpackConfig = generateWebpackConfig({
  plugins: [new Dotenv()],
});

module.exports = webpackConfig
