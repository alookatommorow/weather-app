// See the shakacode/shakapacker README and docs directory for advice on customizing your webpackConfig.
const { generateWebpackConfig } = require('shakapacker')
require('dotenv').config();

const webpackConfig = generateWebpackConfig()

module.exports = webpackConfig
