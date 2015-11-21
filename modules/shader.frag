module.exports = "precision mediump float;\n" +
  "varying vec2 vUv;\n" +
  "uniform sampler2D tex;\n" +
  "void main() {\n" +
  "  vec4 color = texture2D(tex, vUv);\n" +
  "  gl_FragColor = color;\n" +
  "}"