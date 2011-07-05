$(document).ready(function(){
	/* Search Box Setup */
	searchText = 'Enter keywords, then press Enter.';
	searchBox = $('#search_box');
	searchBox.attr('value', searchText);
	
	/* Position Footer */
	var sidebarHeight = $('#sidebar').height();
	var wrapperHeight = $('#wrapper').height();
	var footerHeight = $('#footer').height();
	var padding = 50;
	
	if (sidebarHeight > wrapperHeight) {
		var heightDiff = sidebarHeight - wrapperHeight;
		$('#wrapper').height(wrapperHeight + heightDiff + footerHeight + padding);
	}
})

/* Clears default Search Box text on focus. */
function searchFocus() { 
	if (searchBox.attr('value') == searchText) { 
		searchBox.attr('value', ''); 
	} 
}

/* Calculate Window Height */
function getWindowHeight() {
	var windowHeight = 0;
	if (typeof(window.innerHeight) == 'number') {
		windowHeight = window.innerHeight;
	}
	else {
		if (document.documentElement && document.documentElement.clientHeight) {
			windowHeight = document.documentElement.clientHeight;
		}
		else {
			if (document.body && document.body.clientHeight) {
				windowHeight = document.body.clientHeight;
			}
		}
	}
	return windowHeight;
}

/* Position Footer */
function setFooter() {
	if (document.getElementById) {
		var windowHeight=getWindowHeight();
		if (windowHeight > 0) {
			var contentHeight = document.getElementById('main').offsetHeight;
			var footerElement = document.getElementById('footer');
			var footerHeight = footerElement.offsetHeight;
			if (windowHeight - (contentHeight + footerHeight) >= 0) {
				footerElement.style.position = 'relative';
				footerElement.style.top = (windowHeight - (contentHeight + footerHeight)) + 'px';
			}
			else {
				footerElement.style.position = 'static';
			}
		}
	}
}