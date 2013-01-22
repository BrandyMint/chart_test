$(function () {
  eval($('#code').text());
  prettyPrint();
  $("table") 
  .tablesorter({widthFixed: true, widgets: ['zebra']})
});