$(document)
  .ready(function() {

    $('.ui.dropdown')
      .dropdown({
        on: 'hover'
      });

     $('.masthead .information')
      .transition('scale in');
    
     $('.masthead .bob')
      .transition('tada');

    $('.book .link')
      .hover('scale in');


  });