// Initial variables

$(document).ready(function() {

  var mainSideNavTrigger = $('#mainSideNavTrigger');
  var mainSideNav = $('#mainSideNav');
  var mainContentContainer = $('#mainContentContainer');
  var mainSideNavOpen = false;
  var timer = 550;

  // Listeners
  mainSideNavTrigger.on('click', function() {

    if (mainSideNavOpen === false) {
      mainContentContainer.velocity({
        right: mainSideNav.width()
      }, timer, function() {
        mainSideNav.fadeIn(timer);
      });

      mainSideNavOpen = true;

    } else {

      mainSideNav.fadeOut(timer, function() {
        mainContentContainer.velocity({
          right: '0'
        }, timer );
      });

      mainSideNavOpen = false;

    } // End If Else Statement for open/close
  }); // End SideNavBar Functions

});
