// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
import "material-design-lite/material";
import $ from 'jquery';

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import socket from "./socket"
import "./getmdl-file.js"
import "./getmdl-select.js"

// fixme:
window.showFlashMessages = (message) => {
  const el = document.getElementById('notice');
  if (el && !$.isFunction(MaterialSnackbar)) {
    setTimeout((message) => {
      const bar = el.MaterialSnackbar;
      bar.showSnackbar({
        message: message
      });
    }, 100);
  }
}
