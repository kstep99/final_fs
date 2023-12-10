const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const path = require('path'); // Add this line to import the 'path' module

// Add an alias for the assets directory
environment.config.merge({
  resolve: {
    alias: {
      assets: path.resolve(__dirname, '..', '..', 'app/assets')
    }
  }
});

environment.plugins.append('Provide', new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    'window.jQuery': 'jquery'
}))

module.exports = environment
