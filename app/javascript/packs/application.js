// app/javascript/packs/application.js

// Import the main CSS file (e.g., application.scss)
import '../stylesheets/application'

// You can also include other JavaScript files here
// import './some_other_file'
// import './some_other_file'
import $ from 'jquery';
window.jQuery = $;
window.$ = $;

// Import your custom script
import './tax_updates';
