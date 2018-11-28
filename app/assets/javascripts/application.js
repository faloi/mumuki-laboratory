// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require momentjs
//= require momentjs/locale/es
//= require momentjs/locale/pt
//= require webcomponents-lite
//= require rails-ujs
//= require turbolinks
//= require mumuki-styles
//= require nprogress
//= require nprogress-turbolinks
//= require nprogress-ajax
//= require jquery-console

//= require codemirror.min
//= require codemirror-autorefresh
//= require_tree ../../../vendor/assets/javascripts/codemirror-modes
//= require analytics
//= require hotjar

//= require_tree ./application

NProgress.configure({
  showSpinner: false
});
