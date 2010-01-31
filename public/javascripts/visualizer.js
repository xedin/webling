var canvas;
var ht;

$(document).ready(function() {
  canvas = new Canvas('graphcanvas', {
    'injectInto' : 'graph',
    'width'  : 1000,
    'height' : 750 
  });

  ht = new Hypertree(canvas, {
    Node : {
      color: '#000'
    },
    Edge : {
      color: '#006400'
      //color: '#45FF19'
    },
    onCreateLabel: function(domEl, node) {
      content = '<div> id = ' + node.id + '</div>';
      for(var key in node.data) {
        content += '<div>' + key + ' = ' + node.data[key] + '</div>';
      }
      
      $(domEl).html(content);
      $(domEl).click(function() {
        ht.onClick(node.id);
      });
    },
    onPlaceLabel: function(tag, node) {
      var width = tag.offsetWidth;
      var intX = parseInt(tag.style.left);
      intX -= width / 2;
      tag.style.left = intX + 'px'; 
    }
  });

  $('#graph').hide();
});
