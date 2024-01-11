// Global object for CSF data and functions
os = {
	onLoad: function() {
		if (os.pageCategory) {
			console.log("Found page category");
			activeLink = document.getElementById("navbar_" + os.pageCategory);
			if (activeLink) {
				console.log("Found active link");
				activeLink.classList.add("active");
			}
		}

    // Add styling to "shell" blocks
    // by converting each line into a span with class "line"
    // (and an inner span with class "inner")
    var shell_divs = document.getElementsByClassName("shell");
    var i;
    for (i = 0; i < shell_divs.length; i++) {
      var elt = shell_divs[i];
      if (elt.tagName == 'DIV') {
        // See: https://stackoverflow.com/questions/36803370
        elt.innerHTML =   "<pre><span class='line'><span class='inner'>"
                        + (elt.textContent.split("\n").filter(Boolean).join("</span></span>\n<span class='line'><span class='inner'>"))
                        + "</span></span></pre>"
      }
    }
	}
}

// vim:ts=2:
