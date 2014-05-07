	var currentlyHighlightedDiv = null;
	var lastSeconds = -1;


	function scrollTranscript(evt) {
		var seconds = Math.floor(evt.position);  // round down to nearest second

		// Only proceed if the time is different than when this function was last called.
		// JWPlayer calls this method every 1/10th of a second or so;  rounding the position to the nearest
		// second insures that this event is processed at most once per second.
		// Note that the comparison with lastSeconds is != instead of > because the player may have been
		// moved backwards either with the player's << button or in response to a click on an earlier timestamp
		// in the transcript.
		// Note that it's better to get the current player position from evt.position rather than by calling
		// jwplayer().getPosition() ten times a second, which can interfere with the player's ability
		// to respond to the pause/stop controls.
		if (seconds != lastSeconds) {
			lastSeconds = seconds;

			var div = null;

			// Search backwards to find the first div that would contain the transcript at timepoint "seconds".
			while (div == null & seconds > -1) {
				div = document.getElementById("chunk" + seconds);
				seconds -= 1;
			}

			// Found the right div -- scroll to it and highlight it if it isn't already highlighted
			if (div != null && div != currentlyHighlightedDiv) {
				if (currentlyHighlightedDiv != null) {
					currentlyHighlightedDiv.style.backgroundColor = 'white';
				}

				currentlyHighlightedDiv = div;
				currentlyHighlightedDiv.style.backgroundColor = '#F1F7FF';
				currentlyHighlightedDiv.scrollIntoView(true);
			}
		}
	}


	function jumpPlayerTo(milliseconds) {
		jwplayer().seek(milliseconds / 1000);
	}
