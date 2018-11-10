{
  'use strict';

  window.addEventListener('load', function () {
    getmdlFile.init('.mdl-textfield--file');
  });

  var getmdlFile = {
    addEventListeners: function (file) {
      var upload = file.querySelector('input[type="file"]');

      upload.onchange = function () {
        file.MaterialTextfield.change(upload.files[0].name);
      };
    },
    init: function (selector) {
      var files = document.querySelectorAll(selector);

      [].forEach.call(files, function (i) {
        getmdlFile.addEventListeners(i);
      });
    }
  };
}
