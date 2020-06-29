Webruntime.define('lwc/imageControl', ['lwc'], function (lwc) { 'use strict';

  function stylesheet(hostSelector, shadowSelector, nativeShadow) {
    return ".image" + shadowSelector + "{height: 50px;width: 50px;}\n";
  }
  var _implicitStylesheets = [stylesheet];

  function tmpl($api, $cmp, $slotset, $ctx) {
    const {
      h: api_element
    } = $api;
    return [api_element("a", {
      attrs: {
        "href": $cmp.url,
        "target": "_blank"
      },
      key: 1
    }, [api_element("img", {
      classMap: {
        "image": true
      },
      attrs: {
        "src": $cmp.url,
        "alt": $cmp.altText
      },
      key: 0
    }, [])])];
  }

  var _tmpl = lwc.registerTemplate(tmpl);
  tmpl.stylesheets = [];

  if (_implicitStylesheets) {
    tmpl.stylesheets.push.apply(tmpl.stylesheets, _implicitStylesheets);
  }
  tmpl.stylesheetTokens = {
    hostAttribute: "lwc-imageControl_imageControl-host",
    shadowAttribute: "lwc-imageControl_imageControl"
  };

  class ImageControl extends lwc.LightningElement {
    constructor(...args) {
      super(...args);
      this.url = void 0;
      this.altText = void 0;
    }

  }

  lwc.registerDecorators(ImageControl, {
    publicProps: {
      url: {
        config: 0
      },
      altText: {
        config: 0
      }
    }
  });

  var imageControl = lwc.registerComponent(ImageControl, {
    tmpl: _tmpl
  });

  return imageControl;

});
