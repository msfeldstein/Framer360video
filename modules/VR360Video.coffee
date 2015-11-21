Geometry = require 'gl-geometry'
fit = require 'canvas-fit'
Mat4 = require 'gl-mat4'
GLShader = require 'gl-shader'
CreateTexture = require 'gl-texture2d'
Sphere = require 'primitive-sphere'
OrbitCamera = require 'orbit-camera'
GLContext = require 'gl-context'

class VR360Video
  constructor: (src) ->
    canvas = document.createElement 'canvas'
    document.body.appendChild canvas
    canvas.crossorigin = true

    @camera = OrbitCamera([0,0,0],[0,0,0],[0,0,0])
    doRender = ->
      render()
    gl = GLContext canvas, doRender

    window.addEventListener 'resize', fit(canvas), false

    sphere = Sphere 10, segments: 16

    geometry = Geometry gl
    geometry.attr 'aPosition', sphere.positions
    geometry.attr 'aUv', sphere.uvs, { size: 2 }
    geometry.faces sphere.cells

    projection = Mat4.create()
    model = Mat4.create()
    view = Mat4.create()

    height = 0
    width = 0

    vertexShader = require './shader.vert'
    fragmentShader = require './shader.frag'
    shader = GLShader gl, vertexShader, fragmentShader

    @video = document.createElement 'video'
    @video.src = src
    @video.load()
    @video.play()
    @video.loop = true

    texture = null
    @video.addEventListener 'loadedmetadata', =>
      console.log("Loaded metadata")
      texture = CreateTexture gl, @video
      texture.width = 1920
      texture.height = 960
      
    render = =>
      width = gl.drawingBufferWidth
      height = gl.drawingBufferHeight
      @camera.view view
      
      aspectRatio = width / height
      fieldOfView = Math.PI / 4
      near = 0.01
      far = 100
      
      Mat4.perspective projection, fieldOfView, aspectRatio, near, far
      
      gl.viewport 0, 0, width, height
      gl.enable gl.DEPTH_TEST
      geometry.bind shader
      
      shader.uniforms.uProjection = projection
      shader.uniforms.uView = view
      shader.uniforms.uModel = model
      
      if texture
        texture.setPixels @video
        shader.uniforms.tex = texture.bind()
        
      geometry.draw gl.TRIANGLES
      geometry.unbind()
      
  updatePosition: (newPos)->
    degToRad = Math.PI * 2 / 360
    theta = newPos.heading * degToRad
    phi = newPos.elevation * degToRad
    lookX = Math.sin(theta)
    lookZ = Math.cos(theta)
    center = [0, 0, 0]
    up = [0, 1, 0]
    @camera.lookAt center, [lookX, 0, lookZ], up


module.exports = VR360Video