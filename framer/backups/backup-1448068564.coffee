{VRComponent, VRLayer} = require "VRComponent"

VR360Video = require "VR360Video"
# using six images we create the environment
# images from Humus: http://www.humus.name/index.php?page=Textures
vr = new VRComponent
	front: "images/clear.png"
	right: "images/clear.png"
	left: "images/clear.png"
	back: "images/clear.png"
	bottom: "images/clear.png"
	top: "images/clear.png"
vrVideo = new VR360Video './images/ultralight360.mp4'
# on window resize we make sure the vr component fills the entire screen
window.onresize = ->
	vr.size = Screen.size
	
vr.on Events.OrientationDidChange, (data) ->
	vrVideo.updatePosition(data)