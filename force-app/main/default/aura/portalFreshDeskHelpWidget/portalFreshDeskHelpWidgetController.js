({
	handleClick : function(cmp, event, helper) {
        cmp.set("v.ShowIframe",true);
		console.log('get frame');
        var message = cmp.get("v.message");
        console.log('message '+message );
        var vfOrigin = "https://" + cmp.get("v.vfHost");
        console.log('origin '+vfOrigin);
        var vfWindow = cmp.find("vfFrame").getElement().contentWindow;
        console.log('window ');
        console.log(vfWindow);
        vfWindow.postMessage(message, vfOrigin);
        cmp.set("v.frameHeight","800");
        
        var frame = cmp.find("vfFrame").getElement();
        console.log(frame);
        frame.setAttribute("height", "800px");
        var ht = frame.getAttribute('height');
        console.log('height '+ht);
        
	}
})