$(".burger").on('mouseenter', function(){
  $("#nav-menu").toggleClass("open closed");
  $("#wrapper").toggleClass("menu-open menu-closed");
});
$("#nav-menu").on('mouseleave', function(){
  $("#nav-menu").toggleClass("open closed");
  $("#wrapper").toggleClass("menu-open menu-closed");
});