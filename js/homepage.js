$(document)
  .ready(function() {

    $('.ui.dropdown')
      .dropdown({
        on: 'hover'
      });

     $('.masthead .information')
      .transition('scale in');
    
     $('.masthead .valder')
      .transition('tada');

    $('.toolbar-element').hover(function(){
        $(this).transition('pulse');
    }, function(){});

    $('.display-popup')
      .popup();

  });