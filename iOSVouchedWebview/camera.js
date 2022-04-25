//injects this into webpage to listen to the camera request

(function() {

  if (!window.navigator) window.navigator = {};

    //if getuserMedia is called -> If the user requests native camera

        window.navigator.getUserMedia = function() {

            webkit.messageHandlers.callbackHandler.postMessage(arguments);

  }

})();

